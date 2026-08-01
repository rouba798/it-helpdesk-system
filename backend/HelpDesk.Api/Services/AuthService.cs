using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using HelpDesk.Api.Data;
using HelpDesk.Api.Dtos;
using HelpDesk.Api.Models;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;

namespace HelpDesk.Api.Services;

public class AuthService : IAuthService
{
    private readonly AppDbContext _dbContext;
    private readonly IConfiguration _configuration;

    // Every new self-registered user gets the "Employee" role (RoleId 3, seeded in Week 1).
    // Admin/Agent/Manager accounts should be created or promoted by an Admin, not self-registered.
    private const int DefaultEmployeeRoleId = 3;

    public AuthService(AppDbContext dbContext, IConfiguration configuration)
    {
        _dbContext = dbContext;
        _configuration = configuration;
    }

    public async Task<AuthResponseDto> RegisterAsync(RegisterDto request)
    {
        bool emailTaken = await _dbContext.Users.AnyAsync(u => u.Email == request.Email);
        if (emailTaken)
        {
            throw new InvalidOperationException("That email is already registered.");
        }

        var user = new User
        {
            FullName = request.FullName,
            Email = request.Email,
            PasswordHash = BCrypt.Net.BCrypt.HashPassword(request.Password),
            RoleId = DefaultEmployeeRoleId,
            Department = request.Department,
            IsActive = true,
            CreatedDate = DateTime.UtcNow
        };

        _dbContext.Users.Add(user);
        await _dbContext.SaveChangesAsync();

        return BuildAuthResponse(user, "Employee");
    }

    public async Task<AuthResponseDto> LoginAsync(LoginDto request)
    {
        var user = await _dbContext.Users
            .Include(u => u.Role)
            .FirstOrDefaultAsync(u => u.Email == request.Email);

        if (user is null || !BCrypt.Net.BCrypt.Verify(request.Password, user.PasswordHash))
        {
            throw new UnauthorizedAccessException("Invalid email or password.");
        }

        if (!user.IsActive)
        {
            throw new UnauthorizedAccessException("This account has been deactivated.");
        }

        return BuildAuthResponse(user, user.Role.RoleName);
    }

    private AuthResponseDto BuildAuthResponse(User user, string roleName)
    {
        string token = GenerateJwtToken(user, roleName);
        return new AuthResponseDto
        {
            Token = token,
            FullName = user.FullName,
            Role = roleName
        };
    }

    private string GenerateJwtToken(User user, string roleName)
    {
        var claims = new List<Claim>
        {
            new(ClaimTypes.NameIdentifier, user.UserId.ToString()),
            new(ClaimTypes.Name, user.FullName),
            new(ClaimTypes.Email, user.Email),
            new(ClaimTypes.Role, roleName)
        };

        var key = new SymmetricSecurityKey(
            Encoding.UTF8.GetBytes(_configuration["Jwt:Key"]!));
        var credentials = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);

        var token = new JwtSecurityToken(
            issuer: _configuration["Jwt:Issuer"],
            audience: _configuration["Jwt:Audience"],
            claims: claims,
            expires: DateTime.UtcNow.AddHours(8),
            signingCredentials: credentials
        );

        return new JwtSecurityTokenHandler().WriteToken(token);
    }
}
