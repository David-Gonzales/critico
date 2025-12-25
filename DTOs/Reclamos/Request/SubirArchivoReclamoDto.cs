using System.ComponentModel.DataAnnotations;

namespace DTOs.Reclamos.Request
{
    public class SubirArchivoReclamoDto
    {
        public string NombreArchivo { get; set; } = string.Empty;
        public string ContentType { get; set; } = string.Empty;
        public long TamañoBytes { get; set; }
        public string? RutaArchivo { get; set; } //url de azure
        public Stream? ArchivoStream { get; set; }
    }
}
