using GelirGiderAppApi.Models;
using GelirGiderAppApi.Models.Context;
using GelirGiderAppApi.Models.Entities;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace GelirGiderAppApi.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class UserController : ControllerBase
    {
        private readonly ApiDbContext _context;
        private readonly IPasswordHasher<User> _passwordHasher;

        public UserController(ApiDbContext context, IPasswordHasher<User> passwordHasher)
        {
            _context = context;
            _passwordHasher = passwordHasher;
        }

        [HttpPost("register")]
        public async Task<IActionResult> Register([FromBody] RegisterRequest model)
        {
            // Aynı kullanıcı adı ile zaten bir kullanıcı var mı?
            var existingUser = await _context.Users.FirstOrDefaultAsync(u => u.Username == model.Username);
            if (existingUser != null)
            {
                return BadRequest(new { success = false, message = "Bu kullanıcı adı zaten kullanılıyor" });
            }

            // Yeni kullanıcı oluşturma
            var user = new User
            {
                Username = model.Username,
                // Şifreyi hashleyip kaydediyoruz
                PasswordHash = _passwordHasher.HashPassword(null, model.Password),
                Email = model.Email,
                Phone = model.Phone
            };

            _context.Users.Add(user);
            await _context.SaveChangesAsync();

            return Ok(new { success = true, message = "Kullanıcı başarıyla kaydedildi" });
        }
    }
}
