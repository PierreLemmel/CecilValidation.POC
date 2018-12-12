using CecilValidation.Tests.IL;
using NFluent;
using NUnit.Framework;
using System;
using System.IO;

namespace CecilValidation.Tests.Core.Metatests.Tests
{
    [TestFixture(TestOf = typeof(ILCommentsCleaner))]
    public class ILCommentsCleanerShould
    {
        private readonly ILCommentsCleaner ilCommentsCleaner = new ILCommentsCleaner();

        [Test]
        [TestCase("ILSamples/ILSpyGenerated/FluidImprov.Audio.il", "ILSamples/Expected/FluidImprov.Audio.il")]
        public void ReturnExpectedResults(string inputPath, string expectedPath)
        {
            string inputIlCode = File.ReadAllText(inputPath);
            string expectedResult = File.ReadAllText(expectedPath);

            string result = ilCommentsCleaner.CleanCommentsFromILCode(inputIlCode);

            Check.That(result).IsEqualTo(expectedResult);
        }
    }
}
