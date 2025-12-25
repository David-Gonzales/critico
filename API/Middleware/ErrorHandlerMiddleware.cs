using Common.Exceptions;
using DTOs.Common;
using System.Net;
using System.Text.Json;

namespace API.Middleware
{
    public class ErrorHandlerMiddleware
    {
        private readonly RequestDelegate _next;
        private readonly ILogger<ErrorHandlerMiddleware> _logger;

        public ErrorHandlerMiddleware(RequestDelegate next, ILogger<ErrorHandlerMiddleware> logger)
        {
            _next = next;
            _logger = logger;
        }

        public async Task Invoke(HttpContext context)
        {
            try
            {
                await _next(context);
            }
            catch (Exception error)
            {
                var response = context.Response;
                response.ContentType = "application/json";

                var responseModel = new ApiResponse<string>
                {
                    Success = false,
                    Message = error?.Message ?? "Error desconocido"
                };

                switch (error)
                {
                    case ApiException:
                        response.StatusCode = (int)HttpStatusCode.BadRequest;
                        responseModel.Code = "400";
                        break;

                    case HttpResponseException httpEx:
                        response.StatusCode = httpEx.StatusCode;
                        responseModel.Code = httpEx.StatusCode.ToString();
                        responseModel.Message = httpEx.Value?.ToString() ?? error.Message;
                        break;

                    case KeyNotFoundException:
                        response.StatusCode = (int)HttpStatusCode.NotFound;
                        responseModel.Code = "404";
                        responseModel.Message = "Recurso no encontrado";
                        break;

                    case UnauthorizedAccessException:
                        response.StatusCode = (int)HttpStatusCode.Unauthorized;
                        responseModel.Code = "401";
                        responseModel.Message = "No autorizado";
                        break;

                    case ArgumentException:
                        response.StatusCode = (int)HttpStatusCode.BadRequest;
                        responseModel.Code = "400";
                        break;

                    default:
                        response.StatusCode = (int)HttpStatusCode.InternalServerError;
                        responseModel.Code = "500";
                        responseModel.Message = "Error interno del servidor";
                        break;
                }

                _logger.LogError(error,
                    "Excepción capturada en {Path}. Código HTTP: {StatusCode} - Mensaje: {Message}",
                    context.Request.Path,
                    response.StatusCode,
                    error?.Message);

                _logger.LogInformation(
                    "Detalles del Request: {Method} {Path} | Usuario: {User} | IP: {IP}",
                    context.Request.Method,
                    context.Request.Path,
                    context.User?.Identity?.Name ?? "Anónimo",
                    context.Connection.RemoteIpAddress?.ToString() ?? "Unknown");

                // Solo para desarrollo
                if (context.RequestServices.GetService<IHostEnvironment>()?.IsDevelopment() == true)
                {
                    responseModel.Errors = new List<string>
                    {
                        error.Message,
                        error.StackTrace
                    };
                }

                var result = JsonSerializer.Serialize(responseModel, new JsonSerializerOptions
                {
                    PropertyNamingPolicy = JsonNamingPolicy.CamelCase
                });

                await response.WriteAsync(result);
            }
        }

    }
}
