.class private auto ansi '<Module>'
{
}

.class public auto ansi beforefieldinit FluidImprov.Audio.RealTimeOutputAnalyzer
	extends [mscorlib]System.Object
	implements FluidImprov.Audio.IRealTimeOutputAnalyzer,
	           [mscorlib]System.IDisposable
{
	.field private static literal int32 M = int32(11)
	.field private static literal int32 FFTLength = int32(2048)
	.field private initonly class [NAudio]NAudio.Wave.IWaveIn waveIn
	.field private initonly int32 nbOfChannels
	.field private float32[] spectrum
	.field private valuetype [NAudio]NAudio.Dsp.Complex[] fftBuffer
	.field private int32 fftPos
	.field private class [mscorlib]System.EventHandler`1<class FluidImprov.Audio.AudioAnalyzedEventArgs> AudioAnalyzed
	.custom instance void [mscorlib]System.Runtime.CompilerServices.CompilerGeneratedAttribute::.ctor() = (
		01 00 00 00
	)
	.custom instance void [mscorlib]System.Diagnostics.DebuggerBrowsableAttribute::.ctor(valuetype [mscorlib]System.Diagnostics.DebuggerBrowsableState) = (
		01 00 00 00 00 00 00 00
	)

	.method public hidebysig specialname rtspecialname 
		instance void .ctor () cil managed 
	{
		.maxstack 3

		IL_0000: ldarg.0
		IL_0001: ldc.i4.0
		IL_0002: stfld int32 FluidImprov.Audio.RealTimeOutputAnalyzer::fftPos
		IL_0007: ldarg.0
		IL_0008: call instance void [mscorlib]System.Object::.ctor()
		IL_000d: nop
		IL_000e: nop
		IL_000f: ldarg.0
		IL_0010: ldc.i4 2048
		IL_0015: newarr [mscorlib]System.Single
		IL_001a: stfld float32[] FluidImprov.Audio.RealTimeOutputAnalyzer::spectrum
		IL_001f: ldarg.0
		IL_0020: ldc.i4 2048
		IL_0025: newarr [NAudio]NAudio.Dsp.Complex
		IL_002a: stfld valuetype [NAudio]NAudio.Dsp.Complex[] FluidImprov.Audio.RealTimeOutputAnalyzer::fftBuffer
		IL_002f: ldarg.0
		IL_0030: newobj instance void [NAudio]NAudio.Wave.WasapiLoopbackCapture::.ctor()
		IL_0035: stfld class [NAudio]NAudio.Wave.IWaveIn FluidImprov.Audio.RealTimeOutputAnalyzer::waveIn
		IL_003a: ldarg.0
		IL_003b: ldarg.0
		IL_003c: ldfld class [NAudio]NAudio.Wave.IWaveIn FluidImprov.Audio.RealTimeOutputAnalyzer::waveIn
		IL_0041: callvirt instance class [NAudio]NAudio.Wave.WaveFormat [NAudio]NAudio.Wave.IWaveIn::get_WaveFormat()
		IL_0046: callvirt instance int32 [NAudio]NAudio.Wave.WaveFormat::get_Channels()
		IL_004b: stfld int32 FluidImprov.Audio.RealTimeOutputAnalyzer::nbOfChannels
		IL_0050: ldarg.0
		IL_0051: ldfld class [NAudio]NAudio.Wave.IWaveIn FluidImprov.Audio.RealTimeOutputAnalyzer::waveIn
		IL_0056: ldarg.0
		IL_0057: ldftn instance void FluidImprov.Audio.RealTimeOutputAnalyzer::OnDataAvailable(object, class [NAudio]NAudio.Wave.WaveInEventArgs)
		IL_005d: newobj instance void class [mscorlib]System.EventHandler`1<class [NAudio]NAudio.Wave.WaveInEventArgs>::.ctor(object, native int)
		IL_0062: callvirt instance void [NAudio]NAudio.Wave.IWaveIn::add_DataAvailable(class [mscorlib]System.EventHandler`1<class [NAudio]NAudio.Wave.WaveInEventArgs>)
		IL_0067: nop
		IL_0068: ret
	}

	.method private hidebysig static 
		float32[] CreateFloatArrayFromByteArray (
			uint8[] buffer,
			int32 nbOfBytes
		) cil managed 
	{
		.maxstack 5
		.locals init (
			[0] float32[],
			[1] float32[]
		)

		IL_0000: nop
		IL_0001: ldarg.1
		IL_0002: ldc.i4.4
		IL_0003: div
		IL_0004: newarr [mscorlib]System.Single
		IL_0009: stloc.0
		IL_000a: ldarg.0
		IL_000b: ldc.i4.0
		IL_000c: ldloc.0
		IL_000d: ldc.i4.0
		IL_000e: ldarg.1
		IL_000f: call void [mscorlib]System.Buffer::BlockCopy(class [mscorlib]System.Array, int32, class [mscorlib]System.Array, int32, int32)
		IL_0014: nop
		IL_0015: ldloc.0
		IL_0016: stloc.1
		IL_0017: br.s IL_0019

		IL_0019: ldloc.1
		IL_001a: ret
	}

	.method private hidebysig static 
		float32 Amplitude (
			valuetype [NAudio]NAudio.Dsp.Complex z
		) cil managed 
	{
		.maxstack 3
		.locals init (
			[0] float32
		)

		IL_0000: nop
		IL_0001: ldarg.0
		IL_0002: ldfld float32 [NAudio]NAudio.Dsp.Complex::X
		IL_0007: ldarg.0
		IL_0008: ldfld float32 [NAudio]NAudio.Dsp.Complex::X
		IL_000d: mul
		IL_000e: ldarg.0
		IL_000f: ldfld float32 [NAudio]NAudio.Dsp.Complex::Y
		IL_0014: ldarg.0
		IL_0015: ldfld float32 [NAudio]NAudio.Dsp.Complex::Y
		IL_001a: mul
		IL_001b: add
		IL_001c: conv.r8
		IL_001d: call float64 [mscorlib]System.Math::Sqrt(float64)
		IL_0022: conv.r4
		IL_0023: stloc.0
		IL_0024: br.s IL_0026

		IL_0026: ldloc.0
		IL_0027: ret
	}

	.method private hidebysig 
		instance void OnDataAvailable (
			object sender,
			class [NAudio]NAudio.Wave.WaveInEventArgs args
		) cil managed 
	{
		.maxstack 4
		.locals init (
			[0] float32[],
			[1] int32,
			[2] bool,
			[3] class [mscorlib]System.Collections.Generic.IReadOnlyList`1<float32>,
			[4] int32,
			[5] bool,
			[6] bool
		)

		IL_0000: nop
		IL_0001: ldarg.2
		IL_0002: callvirt instance uint8[] [NAudio]NAudio.Wave.WaveInEventArgs::get_Buffer()
		IL_0007: ldarg.2
		IL_0008: callvirt instance int32 [NAudio]NAudio.Wave.WaveInEventArgs::get_BytesRecorded()
		IL_000d: call float32[] FluidImprov.Audio.RealTimeOutputAnalyzer::CreateFloatArrayFromByteArray(uint8[], int32)
		IL_0012: stloc.0
		IL_0013: ldc.i4.0
		IL_0014: stloc.1
		IL_0015: br IL_0102
			IL_001a: nop
			IL_001b: ldarg.0
			IL_001c: ldfld valuetype [NAudio]NAudio.Dsp.Complex[] FluidImprov.Audio.RealTimeOutputAnalyzer::fftBuffer
			IL_0021: ldarg.0
			IL_0022: ldfld int32 FluidImprov.Audio.RealTimeOutputAnalyzer::fftPos
			IL_0027: ldelema [NAudio]NAudio.Dsp.Complex
			IL_002c: ldloc.0
			IL_002d: ldloc.1
			IL_002e: ldelem.r4
			IL_002f: conv.r8
			IL_0030: ldarg.0
			IL_0031: ldfld int32 FluidImprov.Audio.RealTimeOutputAnalyzer::fftPos
			IL_0036: ldc.i4 2048
			IL_003b: call float64 [NAudio]NAudio.Dsp.FastFourierTransform::HannWindow(int32, int32)
			IL_0040: mul
			IL_0041: conv.r4
			IL_0042: stfld float32 [NAudio]NAudio.Dsp.Complex::X
			IL_0047: ldarg.0
			IL_0048: ldfld valuetype [NAudio]NAudio.Dsp.Complex[] FluidImprov.Audio.RealTimeOutputAnalyzer::fftBuffer
			IL_004d: ldarg.0
			IL_004e: ldfld int32 FluidImprov.Audio.RealTimeOutputAnalyzer::fftPos
			IL_0053: ldelema [NAudio]NAudio.Dsp.Complex
			IL_0058: ldc.r4 0.0
			IL_005d: stfld float32 [NAudio]NAudio.Dsp.Complex::Y
			IL_0062: ldarg.0
			IL_0063: ldarg.0
			IL_0064: ldfld int32 FluidImprov.Audio.RealTimeOutputAnalyzer::fftPos
			IL_0069: ldc.i4.1
			IL_006a: add
			IL_006b: stfld int32 FluidImprov.Audio.RealTimeOutputAnalyzer::fftPos
			IL_0070: ldarg.0
			IL_0071: ldfld int32 FluidImprov.Audio.RealTimeOutputAnalyzer::fftPos
			IL_0076: ldc.i4 2048
			IL_007b: clt
			IL_007d: ldc.i4.0
			IL_007e: ceq
			IL_0080: stloc.2
			IL_0081: ldloc.2
			IL_0082: brfalse.s IL_00f8

			IL_0084: nop
			IL_0085: ldarg.0
			IL_0086: ldc.i4.0
			IL_0087: stfld int32 FluidImprov.Audio.RealTimeOutputAnalyzer::fftPos
			IL_008c: ldc.i4.1
			IL_008d: ldc.i4.s 11
			IL_008f: ldarg.0
			IL_0090: ldfld valuetype [NAudio]NAudio.Dsp.Complex[] FluidImprov.Audio.RealTimeOutputAnalyzer::fftBuffer
			IL_0095: call void [NAudio]NAudio.Dsp.FastFourierTransform::FFT(bool, int32, valuetype [NAudio]NAudio.Dsp.Complex[])
			IL_009a: nop
			IL_009b: ldc.i4.0
			IL_009c: stloc.s 4
			IL_009e: br.s IL_00c3
				IL_00a0: nop
				IL_00a1: ldarg.0
				IL_00a2: ldfld float32[] FluidImprov.Audio.RealTimeOutputAnalyzer::spectrum
				IL_00a7: ldloc.s 4
				IL_00a9: ldarg.0
				IL_00aa: ldfld valuetype [NAudio]NAudio.Dsp.Complex[] FluidImprov.Audio.RealTimeOutputAnalyzer::fftBuffer
				IL_00af: ldloc.s 4
				IL_00b1: ldelem [NAudio]NAudio.Dsp.Complex
				IL_00b6: call float32 FluidImprov.Audio.RealTimeOutputAnalyzer::Amplitude(valuetype [NAudio]NAudio.Dsp.Complex)
				IL_00bb: stelem.r4
				IL_00bc: nop
				IL_00bd: ldloc.s 4
				IL_00bf: ldc.i4.1
				IL_00c0: add
				IL_00c1: stloc.s 4

				IL_00c3: ldloc.s 4
				IL_00c5: ldc.i4 2048
				IL_00ca: clt
				IL_00cc: stloc.s 5
				IL_00ce: ldloc.s 5
				IL_00d0: brtrue.s IL_00a0

			IL_00d2: ldarg.0
			IL_00d3: ldfld float32[] FluidImprov.Audio.RealTimeOutputAnalyzer::spectrum
			IL_00d8: call class [mscorlib]System.Collections.ObjectModel.ReadOnlyCollection`1<!!0> [mscorlib]System.Array::AsReadOnly<float32>(!!0[])
			IL_00dd: stloc.3
			IL_00de: ldarg.0
			IL_00df: ldfld class [mscorlib]System.EventHandler`1<class FluidImprov.Audio.AudioAnalyzedEventArgs> FluidImprov.Audio.RealTimeOutputAnalyzer::AudioAnalyzed
			IL_00e4: dup
			IL_00e5: brtrue.s IL_00ea

			IL_00e7: pop
			IL_00e8: br.s IL_00f7

			IL_00ea: ldarg.0
			IL_00eb: ldloc.3
			IL_00ec: newobj instance void FluidImprov.Audio.AudioAnalyzedEventArgs::.ctor(class [mscorlib]System.Collections.Generic.IReadOnlyList`1<float32>)
			IL_00f1: callvirt instance void class [mscorlib]System.EventHandler`1<class FluidImprov.Audio.AudioAnalyzedEventArgs>::Invoke(object, !0)
			IL_00f6: nop

			IL_00f7: nop

			IL_00f8: nop
			IL_00f9: ldloc.1
			IL_00fa: ldarg.0
			IL_00fb: ldfld int32 FluidImprov.Audio.RealTimeOutputAnalyzer::nbOfChannels
			IL_0100: add
			IL_0101: stloc.1

			IL_0102: ldloc.1
			IL_0103: ldloc.0
			IL_0104: ldlen
			IL_0105: conv.i4
			IL_0106: clt
			IL_0108: stloc.s 6
			IL_010a: ldloc.s 6
			IL_010c: brtrue IL_001a

		IL_0111: ret
	}

	.method public final hidebysig newslot virtual 
		instance void Start () cil managed 
	{
		.maxstack 8

		IL_0000: nop
		IL_0001: ldarg.0
		IL_0002: ldfld class [NAudio]NAudio.Wave.IWaveIn FluidImprov.Audio.RealTimeOutputAnalyzer::waveIn
		IL_0007: callvirt instance void [NAudio]NAudio.Wave.IWaveIn::StartRecording()
		IL_000c: nop
		IL_000d: ret
	}

	.method public final hidebysig newslot virtual 
		instance void Stop () cil managed 
	{
		.maxstack 8

		IL_0000: nop
		IL_0001: ldarg.0
		IL_0002: ldfld class [NAudio]NAudio.Wave.IWaveIn FluidImprov.Audio.RealTimeOutputAnalyzer::waveIn
		IL_0007: callvirt instance void [NAudio]NAudio.Wave.IWaveIn::StopRecording()
		IL_000c: nop
		IL_000d: ret
	}

	.method public final hidebysig newslot virtual 
		instance void Dispose () cil managed 
	{
		.maxstack 8

		IL_0000: nop
		IL_0001: ldarg.0
		IL_0002: ldfld class [NAudio]NAudio.Wave.IWaveIn FluidImprov.Audio.RealTimeOutputAnalyzer::waveIn
		IL_0007: callvirt instance void [mscorlib]System.IDisposable::Dispose()
		IL_000c: nop
		IL_000d: ret
	}

	.method public final hidebysig specialname newslot virtual 
		instance void add_AudioAnalyzed (
			class [mscorlib]System.EventHandler`1<class FluidImprov.Audio.AudioAnalyzedEventArgs> 'value'
		) cil managed 
	{
		.custom instance void [mscorlib]System.Runtime.CompilerServices.CompilerGeneratedAttribute::.ctor() = (
			01 00 00 00
		)
		.maxstack 3
		.locals init (
			[0] class [mscorlib]System.EventHandler`1<class FluidImprov.Audio.AudioAnalyzedEventArgs>,
			[1] class [mscorlib]System.EventHandler`1<class FluidImprov.Audio.AudioAnalyzedEventArgs>,
			[2] class [mscorlib]System.EventHandler`1<class FluidImprov.Audio.AudioAnalyzedEventArgs>
		)

		IL_0000: ldarg.0
		IL_0001: ldfld class [mscorlib]System.EventHandler`1<class FluidImprov.Audio.AudioAnalyzedEventArgs> FluidImprov.Audio.RealTimeOutputAnalyzer::AudioAnalyzed
		IL_0006: stloc.0
			IL_0007: ldloc.0
			IL_0008: stloc.1
			IL_0009: ldloc.1
			IL_000a: ldarg.1
			IL_000b: call class [mscorlib]System.Delegate [mscorlib]System.Delegate::Combine(class [mscorlib]System.Delegate, class [mscorlib]System.Delegate)
			IL_0010: castclass class [mscorlib]System.EventHandler`1<class FluidImprov.Audio.AudioAnalyzedEventArgs>
			IL_0015: stloc.2
			IL_0016: ldarg.0
			IL_0017: ldflda class [mscorlib]System.EventHandler`1<class FluidImprov.Audio.AudioAnalyzedEventArgs> FluidImprov.Audio.RealTimeOutputAnalyzer::AudioAnalyzed
			IL_001c: ldloc.2
			IL_001d: ldloc.1
			IL_001e: call !!0 [mscorlib]System.Threading.Interlocked::CompareExchange<class [mscorlib]System.EventHandler`1<class FluidImprov.Audio.AudioAnalyzedEventArgs>>(!!0&, !!0, !!0)
			IL_0023: stloc.0
			IL_0024: ldloc.0
			IL_0025: ldloc.1
			IL_0026: bne.un.s IL_0007
		IL_0028: ret
	}

	.method public final hidebysig specialname newslot virtual 
		instance void remove_AudioAnalyzed (
			class [mscorlib]System.EventHandler`1<class FluidImprov.Audio.AudioAnalyzedEventArgs> 'value'
		) cil managed 
	{
		.custom instance void [mscorlib]System.Runtime.CompilerServices.CompilerGeneratedAttribute::.ctor() = (
			01 00 00 00
		)
		.maxstack 3
		.locals init (
			[0] class [mscorlib]System.EventHandler`1<class FluidImprov.Audio.AudioAnalyzedEventArgs>,
			[1] class [mscorlib]System.EventHandler`1<class FluidImprov.Audio.AudioAnalyzedEventArgs>,
			[2] class [mscorlib]System.EventHandler`1<class FluidImprov.Audio.AudioAnalyzedEventArgs>
		)

		IL_0000: ldarg.0
		IL_0001: ldfld class [mscorlib]System.EventHandler`1<class FluidImprov.Audio.AudioAnalyzedEventArgs> FluidImprov.Audio.RealTimeOutputAnalyzer::AudioAnalyzed
		IL_0006: stloc.0
			IL_0007: ldloc.0
			IL_0008: stloc.1
			IL_0009: ldloc.1
			IL_000a: ldarg.1
			IL_000b: call class [mscorlib]System.Delegate [mscorlib]System.Delegate::Remove(class [mscorlib]System.Delegate, class [mscorlib]System.Delegate)
			IL_0010: castclass class [mscorlib]System.EventHandler`1<class FluidImprov.Audio.AudioAnalyzedEventArgs>
			IL_0015: stloc.2
			IL_0016: ldarg.0
			IL_0017: ldflda class [mscorlib]System.EventHandler`1<class FluidImprov.Audio.AudioAnalyzedEventArgs> FluidImprov.Audio.RealTimeOutputAnalyzer::AudioAnalyzed
			IL_001c: ldloc.2
			IL_001d: ldloc.1
			IL_001e: call !!0 [mscorlib]System.Threading.Interlocked::CompareExchange<class [mscorlib]System.EventHandler`1<class FluidImprov.Audio.AudioAnalyzedEventArgs>>(!!0&, !!0, !!0)
			IL_0023: stloc.0
			IL_0024: ldloc.0
			IL_0025: ldloc.1
			IL_0026: bne.un.s IL_0007
		IL_0028: ret
	}

	.event class [mscorlib]System.EventHandler`1<class FluidImprov.Audio.AudioAnalyzedEventArgs> AudioAnalyzed
	{
		.addon instance void FluidImprov.Audio.RealTimeOutputAnalyzer::add_AudioAnalyzed(class [mscorlib]System.EventHandler`1<class FluidImprov.Audio.AudioAnalyzedEventArgs>)
		.removeon instance void FluidImprov.Audio.RealTimeOutputAnalyzer::remove_AudioAnalyzed(class [mscorlib]System.EventHandler`1<class FluidImprov.Audio.AudioAnalyzedEventArgs>)
	}


}

.class public auto ansi sealed beforefieldinit FluidImprov.Audio.AudioAnalyzedEventArgs
	extends [mscorlib]System.EventArgs
{
	.field private initonly class [mscorlib]System.Collections.Generic.IReadOnlyList`1<float32> '<Spectrum>k__BackingField'
	.custom instance void [mscorlib]System.Runtime.CompilerServices.CompilerGeneratedAttribute::.ctor() = (
		01 00 00 00
	)
	.custom instance void [mscorlib]System.Diagnostics.DebuggerBrowsableAttribute::.ctor(valuetype [mscorlib]System.Diagnostics.DebuggerBrowsableState) = (
		01 00 00 00 00 00 00 00
	)

	.method public hidebysig specialname 
		instance class [mscorlib]System.Collections.Generic.IReadOnlyList`1<float32> get_Spectrum () cil managed 
	{
		.custom instance void [mscorlib]System.Runtime.CompilerServices.CompilerGeneratedAttribute::.ctor() = (
			01 00 00 00
		)
		.maxstack 8

		IL_0000: ldarg.0
		IL_0001: ldfld class [mscorlib]System.Collections.Generic.IReadOnlyList`1<float32> FluidImprov.Audio.AudioAnalyzedEventArgs::'<Spectrum>k__BackingField'
		IL_0006: ret
	}

	.method public hidebysig specialname rtspecialname 
		instance void .ctor (
			class [mscorlib]System.Collections.Generic.IReadOnlyList`1<float32> spectrum
		) cil managed 
	{
		.maxstack 8

		IL_0000: ldarg.0
		IL_0001: call instance void [mscorlib]System.EventArgs::.ctor()
		IL_0006: nop
		IL_0007: nop
		IL_0008: ldarg.0
		IL_0009: ldarg.1
		IL_000a: stfld class [mscorlib]System.Collections.Generic.IReadOnlyList`1<float32> FluidImprov.Audio.AudioAnalyzedEventArgs::'<Spectrum>k__BackingField'
		IL_000f: ret
	}

	.property instance class [mscorlib]System.Collections.Generic.IReadOnlyList`1<float32> Spectrum()
	{
		.get instance class [mscorlib]System.Collections.Generic.IReadOnlyList`1<float32> FluidImprov.Audio.AudioAnalyzedEventArgs::get_Spectrum()
	}

}

.class interface public auto ansi abstract FluidImprov.Audio.IRealTimeOutputAnalyzer
	implements [mscorlib]System.IDisposable
{
	.method public hidebysig newslot abstract virtual 
		instance void Start () cil managed 
	{
	}

	.method public hidebysig newslot abstract virtual 
		instance void Stop () cil managed 
	{
	}

	.method public hidebysig specialname newslot abstract virtual 
		instance void add_AudioAnalyzed (
			class [mscorlib]System.EventHandler`1<class FluidImprov.Audio.AudioAnalyzedEventArgs> 'value'
		) cil managed 
	{
		.custom instance void [mscorlib]System.Runtime.CompilerServices.CompilerGeneratedAttribute::.ctor() = (
			01 00 00 00
		)
	}

	.method public hidebysig specialname newslot abstract virtual 
		instance void remove_AudioAnalyzed (
			class [mscorlib]System.EventHandler`1<class FluidImprov.Audio.AudioAnalyzedEventArgs> 'value'
		) cil managed 
	{
		.custom instance void [mscorlib]System.Runtime.CompilerServices.CompilerGeneratedAttribute::.ctor() = (
			01 00 00 00
		)
	}

	.event class [mscorlib]System.EventHandler`1<class FluidImprov.Audio.AudioAnalyzedEventArgs> AudioAnalyzed
	{
		.addon instance void FluidImprov.Audio.IRealTimeOutputAnalyzer::add_AudioAnalyzed(class [mscorlib]System.EventHandler`1<class FluidImprov.Audio.AudioAnalyzedEventArgs>)
		.removeon instance void FluidImprov.Audio.IRealTimeOutputAnalyzer::remove_AudioAnalyzed(class [mscorlib]System.EventHandler`1<class FluidImprov.Audio.AudioAnalyzedEventArgs>)
	}


}