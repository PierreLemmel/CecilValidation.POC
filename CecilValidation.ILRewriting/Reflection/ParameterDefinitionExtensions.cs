using Mono.Cecil;
using System;
using System.Linq;

namespace CecilValidation.ILRewriting.Reflection
{
    public static class ParameterDefinitionExtensions
    {
        public static bool HasAttribute<TAttribute>(this ParameterDefinition parameterDefinition) where TAttribute : Attribute
        {
            string fullName = typeof(TAttribute).FullName;

            bool hasAttribute = parameterDefinition
                .CustomAttributes
                .Any(attr => attr.AttributeType.FullName == fullName);

            return hasAttribute;
        }
    }
}
