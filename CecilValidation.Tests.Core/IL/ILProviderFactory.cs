using CecilValidation.Tests.Commands;

namespace CecilValidation.Tests.IL
{
    public static class ILProviderFactory
    {
        public static ILProvider CreateILProvider()
        {
            ProcessRunner processRunner = new ProcessRunner();
            ILReader reader = new ILReader(processRunner);
            ILCommentsCleaner cleaner = new ILCommentsCleaner();

            return new ILProvider(reader, cleaner);
        }
    }
}
