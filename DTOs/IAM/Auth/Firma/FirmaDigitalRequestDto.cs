namespace DTOs.IAM.Auth.Firma
{
    public class FirmaDigitalRequestDto
    {
        public string Email { get; set; }
        public string Password { get; set; }
        public int IdDocumento { get; set; }
        public string TipoDocumento { get; set; }
    }
}
