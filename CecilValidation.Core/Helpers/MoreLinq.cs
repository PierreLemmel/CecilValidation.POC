using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace CecilValidation
{
    public static class MoreLinq
    {
        public static IReadOnlyCollection<T> ToReadOnlyCollection<T>(this IEnumerable<T> sequence) => sequence.ToList();
    }
}
