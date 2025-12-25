using API.Middleware;
using Common.Interfaces;
using Common.Settings;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.IdentityModel.Tokens;
using Repositories.EntidadesFinancieras;
using Repositories.Estados;
using Repositories.IAM;
using Repositories.Menus;
using Repositories.Parametricas;
using Repositories.Reclamos;
using Services.Common;
using Services.EntidadesFinancieras;
using Services.Estados;
using Services.IAM;
using Services.Menus;
using Services.Parametricas;
using Services.Reclamos;
using Services.Storage;
using System.Text;

var builder = WebApplication.CreateBuilder(args);

var databaseSettings = new DatabaseSettings
{
    GetConnectionString = builder.Configuration.GetConnectionString("DefaultConnection")
        ?? throw new InvalidOperationException("ConnectionString 'DefaultConnection' no encontrada en appsettings.json")
};
builder.Services.AddSingleton(databaseSettings);

//JWT Settings
var jwtSettings = new JwtSettings();
builder.Configuration.GetSection("JwtSettings").Bind(jwtSettings);
builder.Services.AddSingleton(jwtSettings);

//JWT Authentication
builder.Services.AddAuthentication(options =>
{
    options.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
    options.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
})
    .AddJwtBearer(options =>
    {
        options.TokenValidationParameters = new TokenValidationParameters
        {
            ValidateIssuer = true,
            ValidateAudience = true,
            ValidateLifetime = true,
            ValidateIssuerSigningKey = true,
            ValidIssuer = jwtSettings.Issuer,
            ValidAudience = jwtSettings.Audience,
            IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(jwtSettings.Key)),
            ClockSkew = TimeSpan.Zero
        };
    });

builder.Services.AddAuthorization();

//Registro de servicios
builder.Services.AddHttpContextAccessor();
builder.Services.AddScoped<IRolRepository, RolRepository>();
builder.Services.AddScoped<IRolService, RolService>();
builder.Services.AddScoped<IJwtService, JwtService>();
builder.Services.AddScoped<IAuthRepository, AuthRepository>();
builder.Services.AddScoped<IAuthService, AuthService>();
builder.Services.AddScoped<IPasswordService, PasswordService>();
builder.Services.AddScoped<IDateTimeService, DateTimeService>();
builder.Services.AddScoped<ITenantService, TenantService>();
builder.Services.AddScoped<IUsuarioRepository, UsuarioRepository>();
builder.Services.AddScoped<IUsuarioService, UsuarioService>();
builder.Services.AddScoped<IPermisoRepository, PermisoRepository>();
builder.Services.AddScoped<IPermisoService, PermisoService>();
builder.Services.AddScoped<IMenuRepository, MenuRepository>();
builder.Services.AddScoped<IMenuService, MenuService>();
builder.Services.AddScoped<IFirmaRepository, FirmaRepository>();
builder.Services.AddScoped<IReclamoRepository, ReclamoRepository>();
builder.Services.AddScoped<IReclamoService, ReclamoService>();
builder.Services.AddScoped<IParametricaRepository, ParametricaRepository>();
builder.Services.AddScoped<IParametricaService, ParametricaService>();
builder.Services.AddScoped<IEstadoReclamoRepository, EstadoReclamoRepository>();
builder.Services.AddScoped<IEstadoReclamoService, EstadoReclamoService>();
builder.Services.AddScoped<IEntidadFinancieraMaestraRepository, EntidadFinancieraMaestraRepository>();
builder.Services.AddScoped<IEntidadFinancieraMaestraService, EntidadFinancieraMaestraService>();
builder.Services.AddScoped<IEntidadFinancieraEmpresaRepository, EntidadFinancieraEmpresaRepository>();
builder.Services.AddScoped<IEntidadFinancieraEmpresaService, EntidadFinancieraEmpresaService>();

var azureBlobSettings = new AzureBlobStorageSettings();
builder.Configuration.GetSection("AzureBlobStorage").Bind(azureBlobSettings);
builder.Services.AddSingleton(azureBlobSettings);
builder.Services.AddScoped<IBlobStorageService, AzureBlobStorageService>();

// Controllers y Swagger
builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(options =>
{
    options.AddSecurityDefinition("Bearer", new Microsoft.OpenApi.Models.OpenApiSecurityScheme
    {
        Name = "Authorization",
        Type = Microsoft.OpenApi.Models.SecuritySchemeType.Http,
        Scheme = "Bearer",
        BearerFormat = "JWT",
        In = Microsoft.OpenApi.Models.ParameterLocation.Header,
        Description = "Ingrese 'Bearer' [espacio] y luego su token en el campo de texto. \n\nEjemplo: \"Bearer abcdef12345\"",
    });

    options.AddSecurityRequirement(new Microsoft.OpenApi.Models.OpenApiSecurityRequirement
    {
        {
            new Microsoft.OpenApi.Models.OpenApiSecurityScheme
            {
                Reference = new Microsoft.OpenApi.Models.OpenApiReference
                {
                    Type = Microsoft.OpenApi.Models.ReferenceType.SecurityScheme,
                    Id = "Bearer"
                }
            },
            Array.Empty<string>()
        }
    });
});


// Configurar CORS para permitir solicitudes desde cualquier origen
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowAll", policy =>
    {
        policy.AllowAnyOrigin()
              .AllowAnyMethod()
              .AllowAnyHeader();
    });
});

var app = builder.Build();

app.UseErrorHandling();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseCors("AllowAll");
app.UseHttpsRedirection();
app.UseAuthentication();
app.UseTenantResolution();
app.UseAuthorization();
app.MapControllers();

app.Run();
