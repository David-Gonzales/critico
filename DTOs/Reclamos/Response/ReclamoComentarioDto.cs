namespace DTOs.Reclamos.Response
{
    public class ReclamoComentarioDto
    {
        public int IdReclamoComentarioDto { get; set; }
        public int IdReclamo { get; set; }
        public string Comentario { get; set; }
        public bool EsInterno { get; set; }
        public DateTime FechaComentario { get; set; }
        public string ComentadoPor { get; set; }
    }
}
