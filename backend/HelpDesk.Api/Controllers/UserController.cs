using HelpDesk.Api.Data;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace HelpDesk.Api.Controllers;

// Example of role-based authorization — only Admin and Manager can list all users.
// Every logged-in user (any role) can view their own profile via GET /api/user/me.
[ApiController]
[Route("api/[controller]")]
[Authorize]
public class UserController : ControllerBase
{
    private readonly AppDbContext _dbContext;

    public UserController(AppDbContext dbContext)
    {
        _dbContext = dbContext;
    }

    [HttpGet]
    [Authorize(Roles = "Admin,Manager")]
    public async Task<IActionResult> GetAllUsers()
    {
        var users = await _dbContext.Users
            .Include(u => u.Role)
            .Select(u => new
            {
                u.UserId,
                u.FullName,
                u.Email,
                RoleName = u.Role.RoleName,
                u.Department,
                u.IsActive
            })
            .ToListAsync();

        return Ok(users);
    }

    [HttpGet("me")]
    public async Task<IActionResult> GetCurrentUser()
    {
        var userIdClaim = User.FindFirst(System.Security.Claims.ClaimTypes.NameIdentifier);
        if (userIdClaim is null)
        {
            return Unauthorized();
        }

        int userId = int.Parse(userIdClaim.Value);
        var user = await _dbContext.Users
            .Include(u => u.Role)
            .Where(u => u.UserId == userId)
            .Select(u => new { u.UserId, u.FullName, u.Email, RoleName = u.Role.RoleName })
            .FirstOrDefaultAsync();

        return user is null ? NotFound() : Ok(user);
    }
}
