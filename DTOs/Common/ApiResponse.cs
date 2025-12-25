namespace DTOs.Common
{
    public class ApiResponse<T>
    {
        public bool Success { get; set; }
        public string Code { get; set; } = "200";
        public string? Message { get; set; }
        public List<string>? Errors { get; set; }
        public T? Data { get; set; }

        public ApiResponse()
        {
            Success = true;
            Code = "200";
            Errors = new List<string>();
        }

        public ApiResponse(string message)
        {
            Success = false;
            Code = "400";
            Message = message;
            Errors = new List<string>();
        }

        public ApiResponse(List<string> errors, string message = "Error en la operación")
        {
            Success = false;
            Code = "400";
            Message = message;
            Errors = errors ?? new List<string>();
        }

        public ApiResponse(T data, string? message = null)
        {
            Success = true;
            Code = "200";
            Data = data;
            Message = message;
            Errors = new List<string>();
        }

        public ApiResponse(bool success, string code, string? message, T? data = default, List<string>? errors = null)
        {
            Success = success;
            Code = code;
            Message = message;
            Data = data;
            Errors = errors ?? new List<string>();
        }
    }
}
