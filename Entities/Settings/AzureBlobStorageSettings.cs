namespace Common.Settings
{
    public class AzureBlobStorageSettings
    {
        public bool UseAccessKey { get; set; }
        public string AccountName { get; set; } = string.Empty;
        public string? AccountKey { get; set; }
        public string ContainerName { get; set; } = string.Empty;
        public bool UseManagedIdentity { get; set; }

        public string GetConnectionString()
        {
            if (UseAccessKey && !string.IsNullOrEmpty(AccountKey))
            {
                return $"DefaultEndpointsProtocol=https;AccountName={AccountName};AccountKey={AccountKey};EndpointSuffix=core.windows.net";
            }

            throw new InvalidOperationException("No se puede generar connection string sin AccountKey en modo Development");
        }

        public Uri GetBlobServiceUri()
        {
            return new Uri($"https://{AccountName}.blob.core.windows.net");
        }
    }
}
