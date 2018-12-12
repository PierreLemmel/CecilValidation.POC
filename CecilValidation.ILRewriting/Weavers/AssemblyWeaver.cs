using CecilValidation.ILRewriting.Reflection;
using Mono.Cecil;
using Mono.Cecil.Cil;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;

namespace CecilValidation.ILRewriting.Weavers
{
    internal class AssemblyWeaver
    {
        public void WeaveAssembly(string assemblyPath, string outPath)
        {
            AssemblyDefinition assemblyDefinition = AssemblyDefinition.ReadAssembly(assemblyPath);

            ModuleDefinition mainModule = assemblyDefinition.MainModule;

            IEnumerable<MethodDefinition> methodsToWeave = mainModule
                .Types
                .SelectMany(type => type.Methods)
                .Where(method => method.Parameters.Any(param => param.HasAttribute<NotNullAttribute>()))
                .ToReadOnlyCollection();

            if (!methodsToWeave.Any()) return;

            Type argumentNullExceptionType = typeof(ArgumentNullException);
            ConstructorInfo exceptionConstructor = argumentNullExceptionType.GetConstructor(new Type[] { });

            MethodReference exConstrRef = mainModule.ImportReference(exceptionConstructor);

            TypeReference boolTypeRef = mainModule.ImportReference(typeof(bool));

            foreach (MethodDefinition method in methodsToWeave)
            {
                ILProcessor ilProcessor = method.Body.GetILProcessor();

                method.Body.Variables.Add(new VariableDefinition(boolTypeRef));

                Instruction firstInstruction = method.Body.Instructions.First();

                foreach (ParameterDefinition param in method.Parameters)
                {
                    if (!param.HasAttribute<NotNullAttribute>()) continue;

                    ilProcessor.InsertBefore(firstInstruction, ilProcessor.Create(OpCodes.Ldarg_0));
                    ilProcessor.InsertBefore(firstInstruction, ilProcessor.Create(OpCodes.Ldnull));
                    ilProcessor.InsertBefore(firstInstruction, ilProcessor.Create(OpCodes.Ceq));
                    ilProcessor.InsertBefore(firstInstruction, ilProcessor.Create(OpCodes.Stloc_0));
                    ilProcessor.InsertBefore(firstInstruction, ilProcessor.Create(OpCodes.Ldloc_0));
                    ilProcessor.InsertBefore(firstInstruction, ilProcessor.Create(OpCodes.Brfalse_S, firstInstruction));
                    ilProcessor.InsertBefore(firstInstruction, ilProcessor.Create(OpCodes.Ldstr, param.Name));
                    ilProcessor.InsertBefore(firstInstruction, ilProcessor.Create(OpCodes.Newobj, exConstrRef));
                    ilProcessor.InsertBefore(firstInstruction, ilProcessor.Create(OpCodes.Throw));
                }
            }

            mainModule.Write(outPath);
        }
    }
}