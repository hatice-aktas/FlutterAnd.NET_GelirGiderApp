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
    public class LoginController : ControllerBase
    {
        private readonly ApiDbContext _context;
        private readonly IPasswordHasher<User> _passwordHasher;

        public LoginController(ApiDbContext context, IPasswordHasher<User> passwordHasher)
        {
            _context = context;
            _passwordHasher = passwordHasher;
        }

        [HttpGet("test")]
        public IActionResult Test()
        {
            return Ok("LoginController çalışıyor. API erişimi başarılı!");
        }

        [HttpPost]
        public async Task<IActionResult> Login([FromBody] LoginRequest model)
        {
            try
            {
                var user = await _context.Users.FirstOrDefaultAsync(u => u.Username == model.Username);

                if (user == null)
                {
                    return Unauthorized(new { success = false, message = "Kullanıcı adı veya şifre hatalı" });
                }

                // Şifre doğrulaması
                var passwordVerificationResult = _passwordHasher.VerifyHashedPassword(user, user.PasswordHash, model.Password);

                if (passwordVerificationResult == PasswordVerificationResult.Failed)
                {
                    return Unauthorized(new { success = false, message = "Kullanıcı adı veya şifre hatalı" });
                }

                // Başarılı giriş
                return Ok(new { success = true, message = "Giriş başarılı." });
            }
            catch (InvalidOperationException ex1)
            {
                return Ok(new { success = false, message = "Giriş başarısız." });
            }
            catch (InvalidDataException ex2)
            {
                return Ok(new { success = false, message = "Giriş başarısız." });
            }
            catch (Exception ex)
            {
                return Ok(new { success = false, message = "Giriş başarısız." });
            }
            
        }

    }

    public class LoginRequest
    {
        public string Username { get; set; }
        public string Password { get; set; }
    }

}
