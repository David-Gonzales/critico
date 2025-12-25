namespace Services.Common
{
    public interface ITenantService
    {
        List<int> ObtenerEmpresasActuales();
        bool TieneAccesoAEmpresa(int idEmpresa);
    }
}
