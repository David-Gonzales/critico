namespace API.Middleware
{
    public class TenantMiddleware
    {
        private readonly RequestDelegate _next;
        public TenantMiddleware(RequestDelegate next)
        {
            _next = next;
        }
        public async Task Invoke(HttpContext context)
        {
            var empresaClaims = context.User?.Claims
                .Where(c => c.Type == "idEmpresa")
                .Select(c => int.Parse(c.Value))
                .ToList();

            if(empresaClaims != null && empresaClaims.Any())
                context.Items["TenantIds"] = empresaClaims;

            await _next(context);
        }
    }
}
