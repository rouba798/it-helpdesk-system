using HelpDesk.Api.Models;
using Microsoft.EntityFrameworkCore;

namespace HelpDesk.Api.Data;

public class AppDbContext : DbContext
{
    public AppDbContext(DbContextOptions<AppDbContext> options) : base(options) { }

    public DbSet<Role> Roles => Set<Role>();
    public DbSet<User> Users => Set<User>();

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        // Table names stay singular per the Week 1 SQL Server Standards,
        // even though the DbSet properties above are plural (a C#/EF convention, not a DB one).
        modelBuilder.Entity<Role>().ToTable("Role");
        modelBuilder.Entity<User>().ToTable("User");

        modelBuilder.Entity<Role>()
            .HasIndex(r => r.RoleName)
            .IsUnique();

        modelBuilder.Entity<User>()
            .HasIndex(u => u.Email)
            .IsUnique();

        modelBuilder.Entity<User>()
            .HasOne(u => u.Role)
            .WithMany(r => r.Users)
            .HasForeignKey(u => u.RoleId);

        // Seed the four roles from Week 1 (matches schema.sql seed data)
        modelBuilder.Entity<Role>().HasData(
            new Role { RoleId = 1, RoleName = "Admin", Description = "Full system access" },
            new Role { RoleId = 2, RoleName = "IT Support Agent", Description = "Manage and resolve tickets" },
            new Role { RoleId = 3, RoleName = "Employee", Description = "Create and track tickets" },
            new Role { RoleId = 4, RoleName = "Manager", Description = "Monitor team tickets and reports" }
        );
    }
}
