﻿using System;
using System.Collections.Generic;

namespace GelirGiderAppApi.Models.Entities;

public partial class Role
{
    public int RoleId { get; set; }

    public string RoleName { get; set; } = null!;
}
