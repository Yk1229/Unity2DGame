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
    private string m_bundleRootPath = "/StreamingAssets/";

    void OnGUI()
    {
        m_bundleRootPath = Application.dataPath + "/StreamingAssets/";
        if (GUILayout.Button("打包", GUILayout.Height(60)))
        {
            BuildAllBundles();
        }
        if (GUILayout.Button("添加lua包", GUILayout.Height(40)))
        {
            ToLuaMenu.BuildNotJitBundles();
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
        BuildAssetBundleOptions options = BuildAssetBundleOptions.DeterministicAssetBundle | BuildAssetBundleOptions.ChunkBasedCompression;
        m_cacheManifest = BuildPipeline.BuildAssetBundles(m_bundleRootPath, options, EditorUserBuildSettings.activeBuildTarget);
        AssetDatabase.Refresh(ImportAssetOptions.ForceUpdate);
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

}
