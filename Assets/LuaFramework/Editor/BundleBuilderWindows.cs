using LuaFramework;
using System.Collections.Generic;
using System.IO;
using UnityEditor;
using UnityEngine;

public class BundleBuilderWindows : EditorWindow
{
    [MenuItem("Tools/BundleBuilder")]
    private static void Open()
    {
        BundleBuilderWindows window = (BundleBuilderWindows)EditorWindow.GetWindow(typeof(BundleBuilderWindows), false, "BundleBuilder");
        window.Show();
    }

    private AssetBundleManifest m_cacheManifest;
    private string m_bundleRootPath = "Assets/" + AppConst.AssetDir;
    static List<string> paths = new List<string>();
    static List<string> files = new List<string>();
    static List<AssetBundleBuild> maps = new List<AssetBundleBuild>();

    void OnGUI()
    {
        m_bundleRootPath = Application.dataPath + "/StreamingAssets/";
        if (GUILayout.Button("打包", GUILayout.Height(60)))
        {
            BuildAllBundles();
        }
        if (GUILayout.Button("添加lua包", GUILayout.Height(40)))
        {
            BuildLuaBundles();
        }
        if (GUILayout.Button("全新打包", GUILayout.Height(40)))
        {
            if (EditorUtility.DisplayDialog("打包", "是否进行全新打包？", "是", "否"))
            {
                BuildAllBundlesNew();
            }
        }
    }

    void BuildAllBundles()
    {
        if (Directory.Exists(Util.DataPath))
        {
            Directory.Delete(Util.DataPath, true);
        }
        string streamPath = Application.streamingAssetsPath;
        if (Directory.Exists(streamPath))
        {
            Directory.Delete(streamPath, true);
        }
        Directory.CreateDirectory(streamPath);
        AssetDatabase.Refresh(ImportAssetOptions.ForceUpdate);
        maps.Clear();
        HandleGameBundle();
        BuildAssetBundleOptions options = BuildAssetBundleOptions.DeterministicAssetBundle | BuildAssetBundleOptions.ChunkBasedCompression;
        m_cacheManifest = BuildPipeline.BuildAssetBundles(m_bundleRootPath, maps.ToArray(), options, EditorUserBuildSettings.activeBuildTarget);
        BuildFileIndex();
        AssetDatabase.Refresh(ImportAssetOptions.ForceUpdate);
    }

    void BuildLuaBundles()
    {
        string streamDir = Application.dataPath + "/" + AppConst.LuaTempDir;
        if (Directory.Exists(streamDir)) Directory.Delete(streamDir, true);
        AssetDatabase.Refresh();
    }

    void BuildAllBundlesNew()
    {
        if (File.Exists(Application.dataPath + "/StreamingAssets.meta"))
        {
            File.Delete(Application.dataPath + "/StreamingAssets.meta");
        }

        if (Directory.Exists(Application.dataPath + "/StreamingAssets"))
        {
            Directory.Delete(Application.dataPath + "/StreamingAssets", true);
        }

        AssetDatabase.Refresh(ImportAssetOptions.ForceUpdate);
        Directory.CreateDirectory(Application.dataPath + "/StreamingAssets");
        AssetDatabase.Refresh(ImportAssetOptions.ForceUpdate);
        BuildAllBundles();
    }

    static void AddBuildMap(string bundleName, string pattern, string path)
    {
        string[] files = Directory.GetFiles(path, pattern);
        if (files.Length == 0) return;

        for (int i = 0; i < files.Length; i++)
        {
            files[i] = files[i].Replace('\\', '/');
        }
        AssetBundleBuild build = new AssetBundleBuild();
        build.assetBundleName = bundleName;
        build.assetNames = files;
        maps.Add(build);
    }

    static void HandleGameBundle()
    {
        string resPath = Application.dataPath.ToLower() + "/" + AppConst.AssetDir + "/";
        if (!Directory.Exists(resPath)) Directory.CreateDirectory(resPath);

        AddBuildMap("login_atlas" + AppConst.ExtName, "*.png", "Assets/LuaFramework/Package/Atlas");
        AddBuildMap("loginView" + AppConst.ExtName, "*.prefab", "Assets/LuaFramework/Package/Prefab/LoginView");
    }

    static void BuildFileIndex()
    {
        string resPath = Application.dataPath.ToLower() + "/StreamingAssets/";
        ///----------------------创建文件列表-----------------------
        string newFilePath = resPath + "/files.txt";
        if (File.Exists(newFilePath)) File.Delete(newFilePath);

        paths.Clear(); files.Clear();
        Recursive(resPath);

        FileStream fs = new FileStream(newFilePath, FileMode.CreateNew);
        StreamWriter sw = new StreamWriter(fs);
        for (int i = 0; i < files.Count; i++)
        {
            string file = files[i];
            string ext = Path.GetExtension(file);
            if (file.EndsWith(".meta") || file.Contains(".DS_Store")) continue;

            string md5 = Util.md5file(file);
            string value = file.Replace(resPath, string.Empty);
            sw.WriteLine(value + "|" + md5);
        }
        sw.Close(); fs.Close();
    }

    static void Recursive(string path)
    {
        string[] names = Directory.GetFiles(path);
        string[] dirs = Directory.GetDirectories(path);
        foreach (string filename in names)
        {
            string ext = Path.GetExtension(filename);
            if (ext.Equals(".meta")) continue;
            files.Add(filename.Replace('\\', '/'));
        }
        foreach (string dir in dirs)
        {
            paths.Add(dir.Replace('\\', '/'));
            Recursive(dir);
        }
    }

}
