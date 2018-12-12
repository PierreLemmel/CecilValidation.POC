using CecilValidation.Samples.Core;
using System;

namespace CecilValidation.Samples.NotNullParameter
{
    public class UserPrinter
    {
        public void Print([NotNull] User user)
        {
            if (user == null) throw new ArgumentNullException(nameof(user));

            Console.WriteLine($"User's ID: {user.ID}");
            Console.WriteLine($"User's FirstName: {user.FirstName}");
            Console.WriteLine($"User's LastName: {user.LastName}");
        }
    }
}