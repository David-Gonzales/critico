using DTOs.IAM.Auth.Firma;

namespace Repositories.IAM
{
    public interface IFirmaRepository
    {
        Task<FirmaDto> ObtenerFirmaActivaPorUsuarioAsync(int idUsuario);
        Task<DocumentoFirmaDto> RegistrarFirmaDocumentoAsync(DocumentoFirmaDto dto);
    }
}
