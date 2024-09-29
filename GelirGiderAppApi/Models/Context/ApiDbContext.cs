using GelirGiderAppApi.Models.Entities;
using Microsoft.EntityFrameworkCore;

namespace GelirGiderAppApi.Models.Context
{
    public class ApiDbContext : DbContext
    {
        public ApiDbContext(DbContextOptions<ApiDbContext> options) : base(options) { }

        public DbSet<User> Users { get; set; }
    }
}
