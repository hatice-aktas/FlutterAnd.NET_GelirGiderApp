using System;
using System.Collections.Generic;

namespace GelirGiderAppApi.Models.Entities;

public partial class User
{
    public int Id { get; set; }

    public string Username { get; set; } = null!;

    public string Email { get; set; } = null!;

    public string Phone { get; set; } = null!;

    public string PasswordHash { get; set; } = null!;

    public DateTime? CreatedAt { get; set; } = DateTime.Now;

    public DateTime? UpdatedAt { get; set; } = DateTime.Now;

    public bool IsEmailVerified { get; set; }

    public virtual ICollection<PasswordResetRequest> PasswordResetRequests { get; set; } = new List<PasswordResetRequest>();
}
