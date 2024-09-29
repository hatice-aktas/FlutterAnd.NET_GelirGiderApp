using System;
using System.Collections.Generic;

namespace GelirGiderAppApi.Models.Entities;

public partial class PasswordResetRequest
{
    public int Id { get; set; }

    public int UserId { get; set; }

    public string ResetToken { get; set; } = null!;

    public DateTime? CreatedAt { get; set; }

    public DateTime ExpiresAt { get; set; }

    public bool? IsUsed { get; set; }

    public virtual User User { get; set; } = null!;
}
