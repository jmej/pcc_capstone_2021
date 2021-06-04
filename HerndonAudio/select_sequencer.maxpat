{
	"patcher" : 	{
		"fileversion" : 1,
		"appversion" : 		{
			"major" : 7,
			"minor" : 3,
			"revision" : 1,
			"architecture" : "x86",
			"modernui" : 1
		}
,
		"rect" : [ 315.0, 81.0, 1063.0, 937.0 ],
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
		"boxes" : [ 			{
				"box" : 				{
					"id" : "obj-84",
					"linecount" : 2,
					"maxclass" : "comment",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 385.5, 226.0, 326.0, 33.0 ],
					"style" : "",
					"text" : "replace counter with [random 7] if you want random stage selection. (you'll also need a [+ 1] after it"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-79",
					"linecount" : 3,
					"maxclass" : "comment",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 369.25, 565.0, 154.0, 47.0 ],
					"style" : "",
					"text" : "these can be events, or parameter shifts - or really anything"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-77",
					"maxclass" : "jit.pwindow",
					"numinlets" : 1,
					"numoutlets" : 2,
					"outlettype" : [ "", "" ],
					"patching_rect" : [ 739.0, 870.0, 169.0, 118.0 ]
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-75",
					"maxclass" : "comment",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 571.0, 751.0, 273.0, 20.0 ],
					"style" : "",
					"text" : "playlist responds to 1-6 but were getting 54-70"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-73",
					"linecount" : 2,
					"maxclass" : "comment",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 571.0, 710.0, 245.0, 33.0 ],
					"style" : "",
					"text" : "sometimes we do some math to get the numbers in the range we want"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-71",
					"maxclass" : "number",
					"numinlets" : 1,
					"numoutlets" : 2,
					"outlettype" : [ "", "bang" ],
					"parameter_enable" : 0,
					"patching_rect" : [ 468.0, 751.0, 50.0, 22.0 ],
					"style" : ""
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-69",
					"maxclass" : "newobj",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "int" ],
					"patching_rect" : [ 527.0, 715.0, 31.0, 22.0 ],
					"style" : "",
					"text" : "- 63"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-68",
					"maxclass" : "comment",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 631.0, 677.0, 150.0, 20.0 ],
					"style" : "",
					"text" : "or video players"
				}

			}
, 			{
				"box" : 				{
					"clipheight" : 29.0,
					"data" : 					{
						"clips" : [ 							{
								"filename" : "bball.mov",
								"filekind" : "moviefile",
								"loop" : 0,
								"content_state" : 								{
									"outputmode" : [ 1 ],
									"out_name" : [ "u583000607" ],
									"dim" : [ 1, 1 ],
									"interp" : [ 0 ],
									"drawto" : [ "" ],
									"moviefile" : [ "" ],
									"position" : [ 0.0 ],
									"usesrcrect" : [ 0 ],
									"loopstart" : [ 0 ],
									"looppoints" : [ 0, 0 ],
									"vol" : [ 1.0 ],
									"loopreport" : [ 0 ],
									"output_texture" : [ 0 ],
									"unique" : [ 0 ],
									"adapt" : [ 1 ],
									"colormode" : [ "argb" ],
									"srcrect" : [ 0, 0, 1, 1 ],
									"time_secs" : [ 0.0 ],
									"framereport" : [ 0 ],
									"autostart" : [ 1 ],
									"time" : [ 0 ],
									"usedstrect" : [ 0 ],
									"loopend" : [ 0 ],
									"engine" : [ "avf" ],
									"texture_name" : [ "u257000605" ],
									"automatic" : [ 0 ],
									"dstrect" : [ 0, 0, 1, 1 ],
									"rate" : [ 1.0 ]
								}

							}
, 							{
								"filename" : "blading.mov",
								"filekind" : "moviefile",
								"loop" : 0,
								"content_state" : 								{
									"outputmode" : [ 1 ],
									"out_name" : [ "u583000607" ],
									"dim" : [ 1, 1 ],
									"interp" : [ 0 ],
									"drawto" : [ "" ],
									"moviefile" : [ "" ],
									"position" : [ 0.0 ],
									"usesrcrect" : [ 0 ],
									"loopstart" : [ 0 ],
									"looppoints" : [ 0, 0 ],
									"vol" : [ 1.0 ],
									"loopreport" : [ 0 ],
									"output_texture" : [ 0 ],
									"unique" : [ 0 ],
									"adapt" : [ 1 ],
									"colormode" : [ "argb" ],
									"srcrect" : [ 0, 0, 1, 1 ],
									"time_secs" : [ 0.0 ],
									"framereport" : [ 0 ],
									"autostart" : [ 1 ],
									"time" : [ 0 ],
									"usedstrect" : [ 0 ],
									"loopend" : [ 0 ],
									"engine" : [ "avf" ],
									"texture_name" : [ "u257000605" ],
									"automatic" : [ 0 ],
									"dstrect" : [ 0, 0, 1, 1 ],
									"rate" : [ 1.0 ]
								}

							}
, 							{
								"filename" : "chickens.mp4",
								"filekind" : "moviefile",
								"loop" : 0,
								"content_state" : 								{
									"outputmode" : [ 1 ],
									"out_name" : [ "u583000607" ],
									"dim" : [ 1, 1 ],
									"interp" : [ 0 ],
									"drawto" : [ "" ],
									"moviefile" : [ "" ],
									"position" : [ 0.0 ],
									"usesrcrect" : [ 0 ],
									"loopstart" : [ 0 ],
									"looppoints" : [ 0, 0 ],
									"vol" : [ 1.0 ],
									"loopreport" : [ 0 ],
									"output_texture" : [ 0 ],
									"unique" : [ 0 ],
									"adapt" : [ 1 ],
									"colormode" : [ "argb" ],
									"srcrect" : [ 0, 0, 1, 1 ],
									"time_secs" : [ 0.0 ],
									"framereport" : [ 0 ],
									"autostart" : [ 1 ],
									"time" : [ 0 ],
									"usedstrect" : [ 0 ],
									"loopend" : [ 0 ],
									"engine" : [ "avf" ],
									"texture_name" : [ "u257000605" ],
									"automatic" : [ 0 ],
									"dstrect" : [ 0, 0, 1, 1 ],
									"rate" : [ 1.0 ]
								}

							}
, 							{
								"filename" : "countdown.mov",
								"filekind" : "moviefile",
								"loop" : 0,
								"content_state" : 								{
									"outputmode" : [ 1 ],
									"out_name" : [ "u583000607" ],
									"dim" : [ 1, 1 ],
									"interp" : [ 0 ],
									"drawto" : [ "" ],
									"moviefile" : [ "" ],
									"position" : [ 0.0 ],
									"usesrcrect" : [ 0 ],
									"loopstart" : [ 0 ],
									"looppoints" : [ 0, 0 ],
									"vol" : [ 1.0 ],
									"loopreport" : [ 0 ],
									"output_texture" : [ 0 ],
									"unique" : [ 0 ],
									"adapt" : [ 1 ],
									"colormode" : [ "argb" ],
									"srcrect" : [ 0, 0, 1, 1 ],
									"time_secs" : [ 0.0 ],
									"framereport" : [ 0 ],
									"autostart" : [ 1 ],
									"time" : [ 0 ],
									"usedstrect" : [ 0 ],
									"loopend" : [ 0 ],
									"engine" : [ "avf" ],
									"texture_name" : [ "u257000605" ],
									"automatic" : [ 0 ],
									"dstrect" : [ 0, 0, 1, 1 ],
									"rate" : [ 1.0 ]
								}

							}
, 							{
								"filename" : "countdown15.mov",
								"filekind" : "moviefile",
								"loop" : 0,
								"content_state" : 								{
									"outputmode" : [ 1 ],
									"out_name" : [ "u583000607" ],
									"dim" : [ 1, 1 ],
									"interp" : [ 0 ],
									"drawto" : [ "" ],
									"moviefile" : [ "" ],
									"position" : [ 0.0 ],
									"usesrcrect" : [ 0 ],
									"loopstart" : [ 0 ],
									"looppoints" : [ 0, 0 ],
									"vol" : [ 1.0 ],
									"loopreport" : [ 0 ],
									"output_texture" : [ 0 ],
									"unique" : [ 0 ],
									"adapt" : [ 1 ],
									"colormode" : [ "argb" ],
									"srcrect" : [ 0, 0, 1, 1 ],
									"time_secs" : [ 0.0 ],
									"framereport" : [ 0 ],
									"autostart" : [ 1 ],
									"time" : [ 0 ],
									"usedstrect" : [ 0 ],
									"loopend" : [ 0 ],
									"engine" : [ "avf" ],
									"texture_name" : [ "u257000605" ],
									"automatic" : [ 0 ],
									"dstrect" : [ 0, 0, 1, 1 ],
									"rate" : [ 1.0 ]
								}

							}
, 							{
								"filename" : "crashtest.mov",
								"filekind" : "moviefile",
								"loop" : 0,
								"content_state" : 								{
									"outputmode" : [ 1 ],
									"out_name" : [ "u583000607" ],
									"dim" : [ 1, 1 ],
									"interp" : [ 0 ],
									"drawto" : [ "" ],
									"moviefile" : [ "" ],
									"position" : [ 0.0 ],
									"usesrcrect" : [ 0 ],
									"loopstart" : [ 0 ],
									"looppoints" : [ 0, 0 ],
									"vol" : [ 1.0 ],
									"loopreport" : [ 0 ],
									"output_texture" : [ 0 ],
									"unique" : [ 0 ],
									"adapt" : [ 1 ],
									"colormode" : [ "argb" ],
									"srcrect" : [ 0, 0, 1, 1 ],
									"time_secs" : [ 0.0 ],
									"framereport" : [ 0 ],
									"autostart" : [ 1 ],
									"time" : [ 0 ],
									"usedstrect" : [ 0 ],
									"loopend" : [ 0 ],
									"engine" : [ "avf" ],
									"texture_name" : [ "u257000605" ],
									"automatic" : [ 0 ],
									"dstrect" : [ 0, 0, 1, 1 ],
									"rate" : [ 1.0 ]
								}

							}
 ]
					}
,
					"id" : "obj-66",
					"maxclass" : "jit.playlist",
					"numinlets" : 1,
					"numoutlets" : 3,
					"outlettype" : [ "jit_matrix", "", "dictionary" ],
					"patching_rect" : [ 527.0, 792.0, 150.0, 180.0 ],
					"style" : ""
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-63",
					"maxclass" : "newobj",
					"numinlets" : 0,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 527.0, 677.0, 79.0, 22.0 ],
					"style" : "",
					"text" : "r seq_values"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-62",
					"maxclass" : "ezdac~",
					"numinlets" : 2,
					"numoutlets" : 0,
					"patching_rect" : [ 87.75, 927.0, 45.0, 45.0 ],
					"style" : ""
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-61",
					"maxclass" : "gain~",
					"numinlets" : 1,
					"numoutlets" : 2,
					"outlettype" : [ "signal", "int" ],
					"parameter_enable" : 0,
					"patching_rect" : [ 87.75, 885.0, 147.0, 20.0 ],
					"style" : ""
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-60",
					"maxclass" : "newobj",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "signal" ],
					"patching_rect" : [ 87.75, 839.0, 45.0, 22.0 ],
					"style" : "",
					"text" : "cycle~"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-57",
					"maxclass" : "comment",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 433.0, 129.0, 393.75, 20.0 ],
					"style" : "",
					"text" : "sends a bang every 500 ms - change argument to change time interval"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-55",
					"maxclass" : "number",
					"numinlets" : 1,
					"numoutlets" : 2,
					"outlettype" : [ "", "bang" ],
					"parameter_enable" : 0,
					"patching_rect" : [ 14.0, 857.0, 50.0, 22.0 ],
					"style" : ""
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-53",
					"maxclass" : "comment",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 128.75, 809.0, 232.5, 20.0 ],
					"style" : "",
					"text" : "mtof translates midi notes to frequencies"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-51",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 87.75, 808.0, 34.0, 22.0 ],
					"style" : "",
					"text" : "mtof"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-50",
					"maxclass" : "newobj",
					"numinlets" : 0,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 87.75, 669.0, 79.0, 22.0 ],
					"style" : "",
					"text" : "r seq_values"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-49",
					"maxclass" : "newobj",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 380.75, 524.0, 101.0, 22.0 ],
					"style" : "",
					"text" : "send seq_values"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-41",
					"maxclass" : "comment",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 228.75, 671.0, 150.0, 20.0 ],
					"style" : "",
					"text" : "like midi notes"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-38",
					"maxclass" : "kslider",
					"numinlets" : 2,
					"numoutlets" : 2,
					"outlettype" : [ "int", "int" ],
					"parameter_enable" : 0,
					"patching_rect" : [ 87.75, 709.0, 336.0, 53.0 ],
					"presentation_rect" : [ 0.0, 0.0, 336.0, 53.0 ],
					"style" : ""
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-37",
					"maxclass" : "message",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 260.0, 462.0, 29.5, 22.0 ],
					"style" : "",
					"text" : "64"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-35",
					"maxclass" : "message",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 517.5, 462.0, 29.5, 22.0 ],
					"style" : "",
					"text" : "70"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-36",
					"maxclass" : "message",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 471.5, 462.0, 29.5, 22.0 ],
					"style" : "",
					"text" : "69"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-33",
					"maxclass" : "message",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 431.5, 462.0, 29.5, 22.0 ],
					"style" : "",
					"text" : "68"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-34",
					"maxclass" : "message",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 344.0, 462.0, 29.5, 22.0 ],
					"style" : "",
					"text" : "66"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-32",
					"maxclass" : "message",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 385.5, 462.0, 29.5, 22.0 ],
					"style" : "",
					"text" : "67"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-28",
					"maxclass" : "message",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 299.0, 462.0, 29.5, 22.0 ],
					"style" : "",
					"text" : "65"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-26",
					"linecount" : 4,
					"maxclass" : "comment",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 575.0, 450.0, 157.0, 60.0 ],
					"style" : "",
					"text" : "commonly we use them to trigger different numbers or values for fx parameters, sounds, video players etc"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-24",
					"linecount" : 3,
					"maxclass" : "comment",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 490.0, 367.0, 230.0, 47.0 ],
					"style" : "",
					"text" : "the outlets of select become 'sequencer stages' can be used to trigger all sorts of things"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-22",
					"linecount" : 2,
					"maxclass" : "comment",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 486.0, 319.0, 261.0, 33.0 ],
					"style" : "",
					"text" : "give select as many arguments as you want to create more outlets / stages for your sequencer"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-20",
					"maxclass" : "number",
					"numinlets" : 1,
					"numoutlets" : 2,
					"outlettype" : [ "", "bang" ],
					"parameter_enable" : 0,
					"patching_rect" : [ 282.0, 241.0, 50.0, 22.0 ],
					"style" : ""
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-15",
					"maxclass" : "number",
					"numinlets" : 1,
					"numoutlets" : 2,
					"outlettype" : [ "", "bang" ],
					"parameter_enable" : 0,
					"patching_rect" : [ 286.0, 129.0, 50.0, 22.0 ],
					"style" : ""
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-13",
					"linecount" : 2,
					"maxclass" : "comment",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 392.0, 79.0, 204.0, 33.0 ],
					"style" : "",
					"text" : "start/stop sequencer by sending a 1 or a 0 to metro"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-11",
					"maxclass" : "toggle",
					"numinlets" : 1,
					"numoutlets" : 1,
					"outlettype" : [ "int" ],
					"parameter_enable" : 0,
					"patching_rect" : [ 361.0, 79.0, 24.0, 24.0 ],
					"style" : ""
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-9",
					"linecount" : 2,
					"maxclass" : "comment",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 447.0, 180.5, 294.0, 33.0 ],
					"style" : "",
					"text" : "Usually you probably want counter to have a range that spans your arguments in [select]"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-7",
					"maxclass" : "newobj",
					"numinlets" : 5,
					"numoutlets" : 4,
					"outlettype" : [ "int", "", "", "int" ],
					"patching_rect" : [ 361.0, 186.0, 71.0, 22.0 ],
					"style" : "",
					"text" : "counter 1 7"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-6",
					"maxclass" : "comment",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 428.0, 155.0, 268.0, 20.0 ],
					"style" : "",
					"text" : "Metro can be replaced with ANY source of bangs"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-4",
					"maxclass" : "newobj",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "bang" ],
					"patching_rect" : [ 361.0, 129.0, 65.0, 22.0 ],
					"style" : "",
					"text" : "metro 500"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-3",
					"maxclass" : "newobj",
					"numinlets" : 8,
					"numoutlets" : 8,
					"outlettype" : [ "bang", "bang", "bang", "bang", "bang", "bang", "bang", "" ],
					"patching_rect" : [ 361.0, 319.0, 112.0, 22.0 ],
					"style" : "",
					"text" : "select 1 2 3 4 5 6 7"
				}

			}
, 			{
				"box" : 				{
					"fontname" : "Courier New",
					"fontsize" : 24.0,
					"id" : "obj-2",
					"maxclass" : "comment",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 318.0, 24.0, 240.0, 34.0 ],
					"style" : "",
					"text" : "Select Sequencer"
				}

			}
 ],
		"lines" : [ 			{
				"patchline" : 				{
					"destination" : [ "obj-15", 0 ],
					"disabled" : 0,
					"hidden" : 0,
					"source" : [ "obj-11", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-4", 0 ],
					"disabled" : 0,
					"hidden" : 0,
					"source" : [ "obj-11", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-49", 0 ],
					"disabled" : 0,
					"hidden" : 0,
					"source" : [ "obj-28", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-28", 0 ],
					"disabled" : 0,
					"hidden" : 0,
					"source" : [ "obj-3", 1 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-32", 0 ],
					"disabled" : 0,
					"hidden" : 0,
					"source" : [ "obj-3", 3 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-33", 0 ],
					"disabled" : 0,
					"hidden" : 0,
					"source" : [ "obj-3", 4 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-34", 0 ],
					"disabled" : 0,
					"hidden" : 0,
					"source" : [ "obj-3", 2 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-35", 0 ],
					"disabled" : 0,
					"hidden" : 0,
					"source" : [ "obj-3", 6 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-36", 0 ],
					"disabled" : 0,
					"hidden" : 0,
					"source" : [ "obj-3", 5 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-37", 0 ],
					"disabled" : 0,
					"hidden" : 0,
					"source" : [ "obj-3", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-49", 0 ],
					"disabled" : 0,
					"hidden" : 0,
					"source" : [ "obj-32", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-49", 0 ],
					"disabled" : 0,
					"hidden" : 0,
					"source" : [ "obj-33", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-49", 0 ],
					"disabled" : 0,
					"hidden" : 0,
					"source" : [ "obj-34", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-49", 0 ],
					"disabled" : 0,
					"hidden" : 0,
					"source" : [ "obj-35", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-49", 0 ],
					"disabled" : 0,
					"hidden" : 0,
					"source" : [ "obj-36", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-49", 0 ],
					"disabled" : 0,
					"hidden" : 0,
					"source" : [ "obj-37", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-51", 0 ],
					"disabled" : 0,
					"hidden" : 0,
					"source" : [ "obj-38", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-7", 0 ],
					"disabled" : 0,
					"hidden" : 0,
					"source" : [ "obj-4", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-38", 0 ],
					"disabled" : 0,
					"hidden" : 0,
					"source" : [ "obj-50", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-55", 0 ],
					"disabled" : 0,
					"hidden" : 0,
					"source" : [ "obj-51", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-60", 0 ],
					"disabled" : 0,
					"hidden" : 0,
					"source" : [ "obj-51", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-61", 0 ],
					"disabled" : 0,
					"hidden" : 0,
					"source" : [ "obj-60", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-62", 1 ],
					"disabled" : 0,
					"hidden" : 0,
					"source" : [ "obj-61", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-62", 0 ],
					"disabled" : 0,
					"hidden" : 0,
					"source" : [ "obj-61", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-69", 0 ],
					"disabled" : 0,
					"hidden" : 0,
					"source" : [ "obj-63", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-77", 0 ],
					"disabled" : 0,
					"hidden" : 0,
					"source" : [ "obj-66", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-66", 0 ],
					"disabled" : 0,
					"hidden" : 0,
					"source" : [ "obj-69", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-71", 0 ],
					"disabled" : 0,
					"hidden" : 0,
					"source" : [ "obj-69", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-20", 0 ],
					"disabled" : 0,
					"hidden" : 0,
					"source" : [ "obj-7", 0 ]
				}

			}
, 			{
				"patchline" : 				{
					"destination" : [ "obj-3", 0 ],
					"disabled" : 0,
					"hidden" : 0,
					"source" : [ "obj-7", 0 ]
				}

			}
 ],
		"dependency_cache" : [ 			{
				"name" : "bball.mov",
				"bootpath" : "C74:/media/jitter",
				"type" : "MooV",
				"implicit" : 1
			}
, 			{
				"name" : "blading.mov",
				"bootpath" : "C74:/media/jitter",
				"type" : "MooV",
				"implicit" : 1
			}
, 			{
				"name" : "chickens.mp4",
				"bootpath" : "C74:/media/jitter",
				"type" : "mpg4",
				"implicit" : 1
			}
, 			{
				"name" : "countdown.mov",
				"bootpath" : "C74:/media/jitter",
				"type" : "MooV",
				"implicit" : 1
			}
, 			{
				"name" : "countdown15.mov",
				"bootpath" : "C74:/media/jitter",
				"type" : "MooV",
				"implicit" : 1
			}
, 			{
				"name" : "crashtest.mov",
				"bootpath" : "C74:/media/jitter",
				"type" : "MooV",
				"implicit" : 1
			}
 ],
		"autosave" : 0
	}

}
