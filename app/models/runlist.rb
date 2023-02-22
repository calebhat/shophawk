class Runlist < ApplicationRecord
#	has_many :departments, through: :department_workcenters
#	has_many :department_workcenters, through: :workcenter
require 'csv'
require 'database_cleaner/active_record'
#The CSV Import code is running as a rake task save in /lib/tasks/csvimport.  It's then ran via a .bat file on the desktop "csvimport.bat", and ran via the windows task scheduler every 5 minutes
	
	def self.importcsv
	runListItems = [] #empties array for new csv import
			old = Runlist.where.not(employee: [nil, ""], dots: [nil, ""], matWaiting: [nil, "", false], Material: [nil, ""]) #saves what's altered to pass on later
			CSV.foreach('app/assets/csv/runListOps.csv', headers: true, :col_sep => "`") do |row| #imports initial csv and creates all arrays needed
				#Below line filters out old/unwanted operations
				if row[2].to_s == "Y-WELD" || row[2].to_s == "---------" || row[2].to_s == "Y-TOOTHRND" || row[2].to_s == "Y-MILL" || row[2].to_s == "Y-KEYSEAT" || row[2].to_s == "Y-HT" || row[2].to_s == "Y-HOB" || row[2].to_s == "Y-GRIND" || row[2].to_s == "Y-BROACH" || row[2].to_s == "REMODEL" || row[2].to_s == "SHIP -HELP" || row[2].to_s == "" || row[2].to_s == "VOLUNTEER" || row[2].to_s == "Y-TURN"
				else
					runListItems << {
			    	Job: row[0], 
			    	Job_Operation: row[1], 
			    	WC_Vendor: row[2],
			    	Operation_Service: row[3],
			    	Vendor: row[4],
			    	Sched_Start: row[5],
			    	Sched_End: row[6],
				    Sequence: row[7],

				    Customer: "", 
						Order_Date: "", 
						Part_Number: "", 
						Rev: "", 
						Description: "", 
						Order_Quantity: "", 
						Extra_Quantity: "", 
						Pick_Quantity: "", 
						Make_Quantity: "",
						Open_Operations: "", 
						Completed_Quantity: "", 
						Shipped_Quantity: "", 
						FG_Transfer_Qty: "", 
						In_Production_Quantity: "", 
						Certs_Required: "", 
						Act_Scrap_Quantity: "", 
						Customer_PO: "", 
						Customer_PO_LN: "", 
						Job_Sched_End: "", 
						Job_Sched_Start: "", 
						Note_Text: "", 
						Released_Date: "",

						Material: "", 
			    		Mat_Vendor: "",
			    		Mat_Description: "",

			    		employee: "",
						dots: "",
						currentOp: "",
						matWaiting: ""
			    	}
			    end
			end
			runListItems.reverse! #reserves array so sequence numbers are in order for current location calculation
			jobs = [] #new array for jobs csv
			CSV.foreach('app/assets/csv/tempjobs.csv', 'r:iso-8859-1:utf-8', :quote_char => "|", headers: true, :col_sep => "`") do |row|
				jobs << {
					Job: row[0],
					Customer: row[1], 
					Order_Date: row[2], 
					Part_Number: row[3], 
					Rev: row[4], 
					Description: row[5], 
					Order_Quantity: row[6], 
					Extra_Quantity: row[7], 
					Pick_Quantity: row[8], 
					Make_Quantity: row[9],
					Open_Operations: row[10], 
					Completed_Quantity: row[11], 
					Shipped_Quantity: row[12], 
					FG_Transfer_Qty: row[13], 
					In_Production_Quantity: row[14], 
					Certs_Required: row[15], 
					Act_Scrap_Quantity: row[16], 
					Customer_PO: row[17], 
					Customer_PO_LN: row[18], 
					Job_Sched_End: row[19], 
					Job_Sched_Start: row[20], 
					Note_Text: row[21], 
					Released_Date: row[22]
				}
			end
			mat = [] #new array for material import
			CSV.foreach('app/assets/csv/tempmat.csv', 'r:iso-8859-1:utf-8', :quote_char => "|", headers: true, :col_sep => "`") do |row|
				mat << {
					Job: row[0],
					Material: row[1], 
			      	Mat_Vendor: row[2],
			      	Mat_Description: row[3]
					}
			end		

			runListItems.each do |items| #parses through each item and merges with mat and jobs array
				schedSrt = items[:Sched_Start].to_s #reorganizes and prepares date field for sorting at end
				if schedSrt == "NULL"
						schedSrt = ""
				else
					year = schedSrt[0..3]
					day = schedSrt[8..9]
					month = schedSrt[5..7]
					items[:Sched_Start] = "#{month}#{day}-#{year}"
				end
				#calculate current location
				if @firstWc == nil #initialize variable
					@firstWc = items[:WC_Vendor]
				end
				if items[:Job] == @lastJob #set currentOp for items
					items[:currentOp] = @firstWc
				else
					@firstWc = items[:WC_Vendor]
					items[:currentOp] = @firstWc
				end
				@lastJob = items[:Job]
				#merge Jobs data
				jobs.each do |row|
					schEnd = row[:Job_Sched_End].to_s #reorganize date field
					if schEnd == "NULL"
						schEnd = ""
					else
						year = schEnd[0..3]
						day = schEnd[8..9]
						month = schEnd[5..7]
						schEnd = "#{month}#{day}-#{year}"
					end
					if items[:Job] == row[:Job] 
						items[:Customer] = row[:Customer]
						items[:Order_Date] = row[:Order_Date]
						items[:Part_Number] = row[:Part_Number]
						items[:Rev] = row[:Rev]
						items[:Description] = row[:Description]
						items[:Order_Quantity] = row[:Order_Quantity]
						items[:Extra_Quantity] = row[:Extra_Quantity]
						items[:Pick_Quantity] = row[:Pick_Quantity]
						items[:Make_Quantity] = row[:Make_Quantity]
						items[:Open_Operations] = row[:Open_Operations]
						items[:Completed_Quantity] = row[:Open_Operations]
						items[:Shipped_Quantity] = row[:Shipped_Quantity]
						items[:FG_Transfer_Qty] = row[:FG_Transfer_Qty]
						items[:In_Production_Quantity] = row[:In_Production_Quantity]
						items[:Certs_Required] = row[:Certs_Required]
						items[:Act_Scrap_Quantity] = row[:Act_Scrap_Quantity]
						items[:Customer_PO] = row[:Customer_PO]
						items[:Customer_PO_LN] = row[:Customer_PO_LN]
						items[:Job_Sched_End] = schEnd
						items[:Job_Sched_Start] = row[:Job_Sched_Start]
						items[:Note_Text] = row[:Note_Text] 
						items[:Released_Date] = row[:Released_Date]
						break
					end
				end
				#merge material data
				mat.each do |row|
					if items[:Job] == row[:Job] 
						items[:Material] = row[:Material]
						items[:Mat_Vendor] = row[:Mat_Vendor]
						items[:Mat_Description] = row[:Mat_Description]
						break
					end
				end
				#imports data previously saved from users into these jobs
				old.each do |data| 
					if data[:Job_Operation].to_s == items[:Job_Operation].to_s
						#binding.pry
						items[:employee] = data.employee
						#items[:currentOp] = data.currentOp
						items[:matWaiting] = data.matWaiting
						items[:dots] = data.dots
						#material is tricky. I don't want to export EVERY materail history with the export script. But it's only exporting material
						#who's operation is still open for, thus removing the material from every following job in the runlist after the saw
						#department completes their operation.  To get around this, we save every runlist op that has material populated, and copy it over
						#to the new data here if the operation still exists. 
						items[:Material] = data.Material
						items[:Mat_Vendor] = data.Mat_Vendor
						items[:Mat_Description] = data.Mat_Description
						break
					end
				end
			end
			DatabaseCleaner.clean_with(:truncation, :only => %w[runlists]) #resets Database
			Runlist.import runListItems #imports new array of hashes to Database
		

			#check for new Workcenters from Jobboss and import if needed
			@wcs = [] #initialize array
			@runlists = Runlist.all #call all runlists
			@runlists.each do |r| #make lists of workcenters
				@wcs << r.WC_Vendor
			end
		    @wcs.uniq! #narrows down array to only be unique workcenters
		    @wcs.sort! { |a,b| a && b ? a <=> b : a ? -1 : 1 } #sorts workcenter alphbetically
			@wcs.each do |a| #check if the WC exists in Workcenter model, if not, save it into the DB
		    if Workcenter.exists?(workCenter: a) #if the workcenter does not exist in our list, add it to the list
		    else
		      @workcenter = Workcenter.new(workCenter: a)
		      @workcenter.save
		    end
		end
	end
end