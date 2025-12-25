namespace Services.Storage
{
    public interface IBlobStorageService
    {
        // Subir archivo a Azure Blob Storage
        Task<string> UploadFileAsync(string fileName, string contentType, Stream fileStream, string? folder = null);

        // Descargar archivo de Azure Blob Storage
        Task<(Stream FileStream, string ContentType, string FileName)> DownloadFileAsync(string blobUrl);

        // Eliminar archivo de Azure Blob Storage
        Task<bool> DeleteFileAsync(string blobUrl);

        // Verificar si un archivo existe
        Task<bool> FileExistsAsync(string blobUrl);
    }
}
