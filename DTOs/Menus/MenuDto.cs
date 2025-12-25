namespace DTOs.Menus
{
    public class MenuDto
    {
        public int IdMenu { get; set; }
        public int IdMenuPadre { get; set; }
        public string Codigo { get; set; }
        public string Nombre { get; set; }
        public string Icono { get; set; }
        public string URL { get; set; }
        public int Orden { get; set; }
        public int? IdEmpresa { get; set; }
        public string NombreEmpresa { get; set; }
        public DateTime FechaCreacion { get; set; }
        public string CreadoPor { get; set; }
        public DateTime? FechaEdicion { get; set; }
        public string EditadoPor { get; set; }
        public bool Activo { get; set; }
    }
}
