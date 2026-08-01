using System.ComponentModel.DataAnnotations.Schema;

namespace HelpDesk.Api.Models;

// Maps to dbo.[User] — bracketed in SQL because USER is a reserved word in T-SQL
[Table("User")]
public class User
{
    public int UserId { get; set; }
    public string FullName { get; set; } = string.Empty;
    public string Email { get; set; } = string.Empty;
    public string PasswordHash { get; set; } = string.Empty;
    public int RoleId { get; set; }
    public string? Department { get; set; }
    public string? ProfileImageUrl { get; set; }
    public bool IsActive { get; set; } = true;
    public DateTime CreatedDate { get; set; } = DateTime.UtcNow;
    public DateTime? UpdatedDate { get; set; }

    public Role Role { get; set; } = null!;
}
