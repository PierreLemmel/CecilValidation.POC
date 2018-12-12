using CecilValidation.ILRewriting.Weavers;
using CecilValidation.Tests.IL;
using CecilValidation.Tests.IO;
using NFluent;
using NUnit.Framework;
using System;
using System.IO;
using System.Reflection;

namespace CecilValidation.Integration
{
    [TestFixture(TestOf = typeof(AssemblyWeaver))]
    public class AssemblyWeaverShould
    {
        private readonly AssemblyWeaver assemblyWeaver = new AssemblyWeaver();
        private readonly ILProvider ilProvider = ILProviderFactory.CreateILProvider();

        private readonly string testedDirectory;
        private readonly string weavedDirectory;
        private readonly string expectedDirectory;

        private string GetExecutingDirectory()
        {
            string testAssemblyLocation = Assembly.GetExecutingAssembly().Location;
            string testAssemblyRunningDirectory = Path.GetDirectoryName(testAssemblyLocation);

            return testAssemblyRunningDirectory;
        }

        public AssemblyWeaverShould()
        {
            string executingDir = GetExecutingDirectory();
            string samplesDir = Path.Combine(executingDir, "SampleAssemblies");

            testedDirectory = Path.Combine(samplesDir, "Tested");
            weavedDirectory = Path.Combine(samplesDir, "Weaved");
            expectedDirectory = Path.Combine(samplesDir, "Expected");
        }

        [OneTimeSetUp]
        public void OneTimeSetup()
        {
            CleanWeavedFile();
            CopyTestedContentToWeavedDirectory();
        }

        private void CleanWeavedFile() => Files.ClearDirectory(weavedDirectory);
        private void CopyTestedContentToWeavedDirectory() => Files.CopyDirectoryContent(testedDirectory, weavedDirectory);

        [Test]
        [TestCase("NotNullParameter")]
        public void WeaveSampleAndCompareWithExpected(string testCase)
        {
            string testedDll = $"CecilValidation.TestedSamples.{testCase}.dll";
            string testedAssemblyPath = Path.Combine(testedDirectory, testCase, testedDll);

            string weavedDll = $"CecilValidation.TestedSamples.{testCase}.dll";
            string weavedAssemblyPath = Path.Combine(weavedDirectory, testCase, weavedDll);

            string expectedDll = $"CecilValidation.ExpectedSamples.{testCase}.dll";
            string expectedAssemblyPath = Path.Combine(expectedDirectory, testCase, expectedDll);

            assemblyWeaver.WeaveAssembly(testedAssemblyPath, weavedAssemblyPath);

            string weavedCode = ilProvider.GetILCodeFromPath(weavedAssemblyPath);
            string expectedCode = ilProvider.GetILCodeFromPath(expectedAssemblyPath);

            Check.That(weavedCode).IsEqualTo(expectedCode);
        }
    }
}