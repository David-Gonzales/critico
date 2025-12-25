namespace Common.Models
{
    public class RefreshToken : AuditableBase
    {
        public int IdRefreshToken { get; set; }
        public int IdUsuario { get; set; }
        public string Token { get; set; }
        public DateTime Expiracion { get; set; }
        public bool EsRevocado { get; set; } = false;
        public DateTime? FechaRevocacion { get; set; }
    }
}
