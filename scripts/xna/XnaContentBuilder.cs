// Builds an unchanged XNA Game Studio 4.0 content project with XNA's own BuildContent task.
// Compiled with mono's mcs and run under Wine by scripts/build-xna-content.sh, which supplies the
// XNA Game Studio assemblies; generalized from the C++ campaign's per-sample runners.
//
// Usage: XnaContentBuilder.exe <contentproj> <outputDir> <intermediateDir> <platform> <profile>
//                              <compress:true|false> [pipelineAssembly ...]
using System;
using System.Collections.Generic;
using System.IO;
using System.Xml;
using Microsoft.Build.Framework;
using Microsoft.Build.Utilities;
using Microsoft.Xna.Framework.Content.Pipeline.Tasks;

internal sealed class ConsoleBuildEngine : IBuildEngine
{
    public bool ContinueOnError { get { return false; } }
    public int LineNumberOfTaskNode { get { return 0; } }
    public int ColumnNumberOfTaskNode { get { return 0; } }
    public string ProjectFileOfTaskNode { get { return "xna-content-builder"; } }
    public bool BuildProjectFile(string projectFileName, string[] targetNames,
        System.Collections.IDictionary globalProperties,
        System.Collections.IDictionary targetOutputs) { return false; }
    public void LogCustomEvent(CustomBuildEventArgs e) { Console.WriteLine(e.Message); }
    public void LogErrorEvent(BuildErrorEventArgs e) { Console.Error.WriteLine("error: " + e.File + ": " + e.Message); }
    public void LogMessageEvent(BuildMessageEventArgs e) { Console.WriteLine(e.Message); }
    public void LogWarningEvent(BuildWarningEventArgs e) { Console.Error.WriteLine("warning: " + e.File + ": " + e.Message); }
}

internal static class Program
{
    // Every <Compile> row of the content project with its own metadata (Name, Importer, Processor,
    // ProcessorParameters_*), as XNA's own targets hand them to BuildContent.
    private static ITaskItem[] ReadAssets(string project, out string guid)
    {
        var document = new XmlDocument();
        document.Load(project);
        var manager = new XmlNamespaceManager(document.NameTable);
        manager.AddNamespace("m", "http://schemas.microsoft.com/developer/msbuild/2003");
        XmlNode guidNode = document.SelectSingleNode("/m:Project/m:PropertyGroup/m:ProjectGuid", manager);
        guid = guidNode == null ? "{00000000-0000-0000-0000-000000000000}" : guidNode.InnerText;
        string root = Path.GetDirectoryName(project);
        var assets = new List<ITaskItem>();
        foreach (XmlElement node in document.SelectNodes("/m:Project/m:ItemGroup/m:Compile", manager))
        {
            // XACT projects go through XactBld3.exe, the tool XNA's own XACT importer runs; the
            // script builds them beside this task's output.
            if (node.GetAttribute("Include").EndsWith(".xap", StringComparison.OrdinalIgnoreCase))
                continue;
            var item = new TaskItem(Path.Combine(root, node.GetAttribute("Include")));
            foreach (XmlNode child in node.ChildNodes)
                if (child is XmlElement)
                    item.SetMetadata(child.LocalName, child.InnerText);
            // SongProcessor encodes through the Windows Media Format writer, which does not run under
            // Wine, and BuildContent stops at its first failed asset: listed, not attempted.
            if (item.GetMetadata("Processor") == "SongProcessor")
            {
                Console.WriteLine("skipped song: " + node.GetAttribute("Include") + " as " + item.GetMetadata("Name"));
                continue;
            }
            // VideoProcessor reads the video through Windows Media Format as well, and fails the same way.
            if (item.GetMetadata("Processor") == "VideoProcessor")
            {
                Console.WriteLine("skipped video: " + node.GetAttribute("Include") + " as " + item.GetMetadata("Name"));
                continue;
            }
            assets.Add(item);
        }
        Console.WriteLine("content project: " + assets.Count + " assets");
        return assets.ToArray();
    }

    private static int Main(string[] args)
    {
        if (args.Length < 6)
        {
            Console.Error.WriteLine("usage: XnaContentBuilder <contentproj> <out> <obj> <platform> <profile> <compress> [pipeline.dll ...]");
            return 2;
        }

        try
        {
            string guid;
            ITaskItem[] assets = ReadAssets(args[0], out guid);
            var pipeline = new List<ITaskItem>();
            for (int i = 6; i < args.Length; i++)
                pipeline.Add(new TaskItem(args[i]));
            var task = new BuildContent
            {
                BuildEngine = new ConsoleBuildEngine(),
                ContentProjectGUID = guid,
                BuildConfiguration = "Release",
                IntermediateDirectory = args[2],
                OutputDirectory = args[1],
                PipelineAssemblies = pipeline.ToArray(),
                RebuildAll = true,
                RootDirectory = Path.GetDirectoryName(args[0]),
                LoggerRootDirectory = Path.GetDirectoryName(args[0]),
                SourceAssets = assets,
                TargetPlatform = args[3],
                TargetProfile = args[4],
                CompressContent = args[5] == "true"
            };
            bool ok = task.Execute();
            Console.WriteLine("BuildContent " + args[3] + "/" + args[4] + ": " + (ok ? "succeeded" : "FAILED"));
            return ok ? 0 : 1;
        }
        catch (Exception e)
        {
            Console.Error.WriteLine(e);
            return 1;
        }
    }
}
