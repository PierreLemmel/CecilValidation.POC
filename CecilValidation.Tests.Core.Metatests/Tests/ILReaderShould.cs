using CecilValidation.Tests.Commands;
using CecilValidation.Tests.IL;
using NFluent;
using NUnit.Framework;

namespace CecilValidation.Tests.Core.Metatests.Tests
{
    [TestFixture(TestOf = typeof(ILReader))]
    public class ILReaderShould
    {
        private readonly ILReader ilReader = new ILReader(new ProcessRunner());

        [Test]
        [TestCase("SomeDlls/FluidImprov.Audio.dll")]
        public void Return_Some_Result_WhenCorrect_Path_Is_Provided(string path)
        {
            string result = ilReader.ReadILCodeFromAssembly(path);

            Check.That(result).Not.IsNullOrEmpty();
        }
    }
}
