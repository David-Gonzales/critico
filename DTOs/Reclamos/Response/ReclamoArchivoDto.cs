namespace DTOs.Reclamos.Response
{
    public class ReclamoArchivoDto
    {
        public int IdReclamoArchivo { get; set; }
        public int IdReclamo { get; set; }
        public string NombreArchivo { get; set; }
        public string NombreOriginal { get; set; }
        public string RutaArchivo { get; set; }
        public long TamañoBytes { get; set; }
        public string ContentType { get; set; }
        public string TipoArchivo { get; set; }
        public string? Descripcion { get; set; }
        public DateTime FechaSubida { get; set; }
        public string SubidoPor { get; set; }
    }
}
