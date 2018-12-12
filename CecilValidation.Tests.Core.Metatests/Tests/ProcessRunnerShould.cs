using CecilValidation.Tests.Commands;
using NFluent;
using NUnit.Framework;

namespace CecilValidation.Tests.Core.Metatests.Tests
{
    [TestFixture(TestOf = typeof(ProcessRunner))]
    public class ProcessRunnerShould
    {
        private readonly ProcessRunner processRunner = new ProcessRunner();

        [Test]
        [TestCase("echo Hello world!", "Hello world!")]
        public void Return_Result_Printed_In_Standard_Output(string command, string expected)
        {
            string result = processRunner.ExecuteCommand(command);

            Check.That(result).IsEqualTo(expected);
        }

        [Test]
        [TestCase("dotnet somemissingassembly.dll")]
        public void Throw_ProcessException_When_Process_Writes_In_StandardError(string command)
        {
            Check.ThatCode(() => processRunner.ExecuteCommand(command))
                .Throws<ProcessException>();
        }
    }
}
