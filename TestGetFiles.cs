using Godot;
using System;

public partial class TestGetFiles : RichTextLabel
{
	[Export] public string rootPath = "./";
	
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		DirContents(rootPath);
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
	}
	
	
	public void DirContents(string path)
	{
		Text = "";
		using var dir = DirAccess.Open(path);
		if (dir != null)
		{
			dir.ListDirBegin();
			string fileName = dir.GetNext();
			while (fileName != "")
			{
				if (dir.CurrentIsDir())
				{
					//GD.Print($"directory: {fileName}");
				}
				else
				{
					//GD.Print($"--> {fileName}");
					Text += $"--> {fileName} \n";
				}
				fileName = dir.GetNext();
			}
		}
		else
		{
			GD.Print("An error occurred when trying to access the path.");
		}
	}
}
