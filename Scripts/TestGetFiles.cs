//using Godot;
//using System;
//using System.Collections;
//using System.Collections.Generic;
//
//public partial class TestGetFiles : Node
//{
	//[Export] public string rootPath = "./";
	//[Export] public Node itemParent;
	//[Export] public PackedScene itemScene;
	//public Dictionary<String, Item> itemsDict = new Dictionary<String, Item>();
	//
	//// Called when the node enters the scene tree for the first time.
	//public override void _Ready()
	//{
		//// DirContents(rootPath);
		//
		//// foreach ( string s in itemsDict.Keys )
		//// {
		//// 	itemsDict.Add( s, Instanciate(itemScene, itemParent) );
		//// }
	//}
	//
	//
	//public void DirContents(string path)
	//{
		////Text = "";
		//using var dir = DirAccess.Open(path);
		//if (dir != null)
		//{
			//dir.ListDirBegin();
			//string fileName = dir.GetNext();
			//while (fileName != "")
			//{
				//if (dir.CurrentIsDir())
				//{
					////GD.Print($"directory: {fileName}");
				//}
				//else
				//{
					////GD.Print($"--> {fileName}");
					////Text += $"--> {fileName} \n";
					//itemsDict.Add(fileName, new Item());
				//}
				//fileName = dir.GetNext();
			//}
		//}
		//else
		//{
			//GD.Print("An error occurred when trying to access the path.");
		//}
	//}
//}
