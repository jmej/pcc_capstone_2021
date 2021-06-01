{
	"patcher" : 	{
		"fileversion" : 1,
		"appversion" : 		{
			"major" : 8,
			"minor" : 1,
			"revision" : 9,
			"architecture" : "x64",
			"modernui" : 1
		}
,
		"classnamespace" : "box",
		"rect" : [ 228.0, 344.0, 1062.0, 641.0 ],
		"bglocked" : 0,
		"openinpresentation" : 0,
		"default_fontsize" : 12.0,
		"default_fontface" : 0,
		"default_fontname" : "Arial",
		"gridonopen" : 1,
		"gridsize" : [ 15.0, 15.0 ],
		"gridsnaponopen" : 1,
		"objectsnaponopen" : 1,
		"statusbarvisible" : 2,
		"toolbarvisible" : 1,
		"lefttoolbarpinned" : 0,
		"toptoolbarpinned" : 0,
		"righttoolbarpinned" : 0,
		"bottomtoolbarpinned" : 0,
		"toolbars_unpinned_last_save" : 0,
		"tallnewobj" : 0,
		"boxanimatetime" : 200,
		"enablehscroll" : 1,
		"enablevscroll" : 1,
		"devicewidth" : 0.0,
		"description" : "",
		"digest" : "",
		"tags" : "",
		"style" : "",
		"subpatcher_template" : "",
		"assistshowspatchername" : 0,
		"boxes" : [ 			{
				"box" : 				{
					"id" : "obj-4",
					"maxclass" : "newobj",
					"numinlets" : 0,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 504.666625916957855, 44.0, 93.0, 22.0 ],
					"text" : "r SampleLength"
				}

			}
, 			{
				"box" : 				{
					"comment" : "",
					"id" : "obj-1",
					"index" : 2,
					"maxclass" : "inlet",
					"numinlets" : 0,
					"numoutlets" : 1,
					"outlettype" : [ "signal" ],
					"patching_rect" : [ 764.0, 44.0, 30.0, 30.0 ]
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-5",
					"maxclass" : "comment",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 809.0, 49.0, 93.0, 20.0 ],
					"text" : "Inlets for audio"
				}

			}
, 			{
				"box" : 				{
					"comment" : "",
					"id" : "obj-3",
					"index" : 1,
					"maxclass" : "inlet",
					"numinlets" : 0,
					"numoutlets" : 1,
					"outlettype" : [ "signal" ],
					"patching_rect" : [ 717.0, 44.0, 30.0, 30.0 ]
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-147",
					"maxclass" : "newobj",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "bang" ],
					"patching_rect" : [ 578.333348035812378, 150.369465172290802, 37.0, 22.0 ],
					"text" : "delay"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-146",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 2,
					"outlettype" : [ "bang", "float" ],
					"patching_rect" : [ 578.333348035812378, 111.70279735326767, 29.5, 22.0 ],
					"text" : "t b f"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-145",
					"maxclass" : "message",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 390.166625380516052, 340.053079187870026, 81.0, 22.0 ],
					"text" : "/maxaudio $1"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-143",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 390.166625380516052, 373.702805161476135, 142.0, 22.0 ],
					"text" : "udpsend localhost 12001"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-110",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 2,
					"outlettype" : [ "float", "bang" ],
					"patching_rect" : [ 506.416625916957855, 111.481990873813629, 29.5, 22.0 ],
					"text" : "t f b"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-108",
					"maxclass" : "message",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 211.000003755092621, 280.369469046592712, 83.0, 22.0 ],
					"text" : "open $1 wave"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-101",
					"maxclass" : "message",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 240.999952912330627, 121.036130249500275, 32.0, 22.0 ],
					"text" : "ticks"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-85",
					"maxclass" : "message",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 85.0, 214.369426250457764, 107.333335041999817, 22.0 ],
					"text" : "136059074.wav"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-78",
					"maxclass" : "newobj",
					"numinlets" : 2,
					"numoutlets" : 2,
					"outlettype" : [ "", "" ],
					"patching_rect" : [ 261.999952912330627, 231.036130249500275, 131.0, 22.0 ],
					"text" : "combine filename .wav"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-30",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 3,
					"outlettype" : [ "list", "list", "int" ],
					"patching_rect" : [ 240.999952912330627, 156.369428038597107, 40.0, 22.0 ],
					"text" : "date"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-52",
					"maxclass" : "message",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 538.666625916957855, 251.369426250457764, 59.0, 22.0 ],
					"text" : "record $1"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-28",
					"maxclass" : "newobj",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "signal" ],
					"patching_rect" : [ 520.166625916957855, 344.186412870883942, 69.0, 22.0 ],
					"text" : "sfrecord~ 2"
				}

			}
 ],
		"lines" : [ 			{
				"patchline" : 				{
					"destination" : [ "obj-28", 1 ],
					"source" : [ "obj-1", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-30", 0 ],
					"source" : [ "obj-101", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-28", 0 ],
					"source" : [ "obj-108", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-101", 0 ],
					"source" : [ "obj-110", 1 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-52", 0 ],
					"source" : [ "obj-110", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-143", 0 ],
					"source" : [ "obj-145", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-147", 1 ],
					"source" : [ "obj-146", 1 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-147", 0 ],
					"source" : [ "obj-146", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-85", 0 ],
					"source" : [ "obj-147", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-28", 0 ],
					"source" : [ "obj-3", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-78", 0 ],
					"source" : [ "obj-30", 2 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-110", 0 ],
					"order" : 1,
					"source" : [ "obj-4", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-146", 0 ],
					"order" : 0,
					"source" : [ "obj-4", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-28", 0 ],
					"source" : [ "obj-52", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-108", 0 ],
					"order" : 0,
					"source" : [ "obj-78", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-85", 1 ],
					"order" : 1,
					"source" : [ "obj-78", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-145", 0 ],
					"midpoints" : [ 94.5, 326.369426250457764, 399.666625380516052, 326.369426250457764 ],
					"source" : [ "obj-85", 0 ]
				}

			}
 ]
	}

}
