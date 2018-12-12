using System;

namespace CecilValidation
{
    [AttributeUsage(AttributeTargets.Parameter, AllowMultiple = false)]
    public class NotNullAttribute : Attribute
    {
    }
}
