using Azure.Identity;
using Azure.Storage.Blobs;
using Azure.Storage.Blobs.Models;
using Common.Exceptions;
using Common.Settings;

namespace Services.Storage
{
    public class AzureBlobStorageService : IBlobStorageService
    {
        private readonly BlobServiceClient _blobServiceClient;
        private readonly BlobContainerClient _containerClient;
        private readonly AzureBlobStorageSettings _settings;

        public AzureBlobStorageService( AzureBlobStorageSettings settings)
        {
            _settings = settings;

            // Para desarrollo usar Access Key
            if (_settings.UseAccessKey)
            {
                
                var connectionString = _settings.GetConnectionString();
                _blobServiceClient = new BlobServiceClient(connectionString);
            }
            // Para producción usar Managed Identity (Azure AD)
            else if (_settings.UseManagedIdentity)
            {
                var blobServiceUri = _settings.GetBlobServiceUri();
                _blobServiceClient = new BlobServiceClient(blobServiceUri, new DefaultAzureCredential());
            }
            else
            {
                throw new InvalidOperationException("Debe configurar UseAccessKey o UseManagedIdentity");
            }

            _containerClient = _blobServiceClient.GetBlobContainerClient(_settings.ContainerName);
        }

        public async Task<string> UploadFileAsync(
            string fileName,
            string contentType,
            Stream fileStream,
            string? folder = null)
        {
            try
            {
                // Construyo el nombre del blob con estructura de carpetas
                var blobName = string.IsNullOrEmpty(folder)
                    ? fileName
                    : $"{folder}/{fileName}";

                var blobClient = _containerClient.GetBlobClient(blobName);

                // Configuro los headers
                var blobHttpHeaders = new BlobHttpHeaders
                {
                    ContentType = contentType
                };

                // Subo el archivo
                await blobClient.UploadAsync(fileStream, new BlobUploadOptions
                {
                    HttpHeaders = blobHttpHeaders
                });

                // Retorno URL pública
                return blobClient.Uri.ToString();
            }
            catch (Exception ex)
            {
                throw new ApiException($"Error al subir archivo a Azure Blob Storage: {ex.Message}");
            }
        }

        public async Task<(Stream FileStream, string ContentType, string FileName)> DownloadFileAsync(string blobUrl)
        {
            try
            {
                var blobName = ExtractBlobNameFromUrl(blobUrl);
                var blobClient = _containerClient.GetBlobClient(blobName);

                // Verifico que existe
                if (!await blobClient.ExistsAsync())
                    throw new ApiException("El archivo no existe");

                // Descargo el archivo
                var response = await blobClient.DownloadAsync();
                var properties = await blobClient.GetPropertiesAsync();

                var fileName = Path.GetFileName(blobName);
                var contentType = properties.Value.ContentType;

                return (response.Value.Content, contentType, fileName);
            }
            catch (Exception ex)
            {
                throw new ApiException($"Error al descargar archivo de Azure Blob Storage: {ex.Message}");
            }
        }

        public async Task<bool> DeleteFileAsync(string blobUrl)
        {
            try
            {
                var blobName = ExtractBlobNameFromUrl(blobUrl);
                var blobClient = _containerClient.GetBlobClient(blobName);

                var result = await blobClient.DeleteIfExistsAsync();
                return result.Value;
            }
            catch (Exception ex)
            {
                throw new ApiException($"Error al eliminar archivo de Azure Blob Storage: {ex.Message}");
            }
        }

        public async Task<bool> FileExistsAsync(string blobUrl)
        {
            try
            {
                var blobName = ExtractBlobNameFromUrl(blobUrl);
                var blobClient = _containerClient.GetBlobClient(blobName);

                return await blobClient.ExistsAsync();
            }
            catch (Exception ex)
            {
                return false;
            }
        }

        private string ExtractBlobNameFromUrl(string blobUrl)
        {
            // Si es solo el nombre
            if (!blobUrl.StartsWith("http"))
                return blobUrl;

            // Si es URL completa, extraer nombre del blob
            var uri = new Uri(blobUrl);
            var blobName = uri.AbsolutePath.TrimStart('/');

            // Remuevo el nombre del contenedor si está presente
            if (blobName.StartsWith($"{_settings.ContainerName}/"))
                blobName = blobName.Substring(_settings.ContainerName.Length + 1);

            return blobName;
        }
    }
}
