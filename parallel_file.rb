require 'jruby/profiler'

profile_data = ''
def cosine()
    @time1 = Time.now
    documents = []
    read_threads = []
    Dir.glob('./sample/*.keys') do |all_keys_file|
	file = File.read(all_keys_file).split("\n")
	@doc = {}
    	file.each_with_index do |line,index|      
      		data = line.split(" ")
		@doc[data[0]] = data[1]
    	end
	documents << @doc
    end
    #cosine Similarity
    @times = []
    @similarities = []
    (0..(documents.length-1)).each do |ind|
      data_array = []
      time_array = []
      (0..ind).each do |indj|
        time1 = Time.now
        num = 0
        denom1  = 0
        denom2 = 0
        documents[ind].each do |k,v|
          if (!documents[indj][k].nil?) && (documents[indj][k].to_i > 0) && (documents[ind][k].to_i > 0)
                num += documents[ind][k].to_i*documents[indj][k].to_i
                denom1 += documents[ind][k].to_i*documents[ind][k].to_i
                denom2 += documents[indj][k].to_i*documents[indj][k].to_i
          end  
        end
        sq_rt_denom1 = Math.sqrt(denom1)
        sq_rt_denom2 = Math.sqrt(denom2)
        @similarity = (num.to_f)/(sq_rt_denom1.to_f * sq_rt_denom2.to_f) #/
        time2 = Time.now
        time_array << time2 - time1
        data_array << @similarity        
      end
      @times << time_array
      @similarities << data_array
    end 
     @similarities.inspect 
	 File.open('squence_output', 'w') do |f1|  
	  count = Dir[File.join("./samples", '**', '*')].count { |file| File.file?(file) }
	  f1.write(count)
	  f1.write(Time.now - @time1)
	 end  
     puts Time.now - @time1
end


def cosine_parallel()    
    @time1 = Time.now
	somefile = File.open("./thread_out.txt", "w")		
    documents = []
    read_threads = []
    Dir.glob('./sample/*.keys') do |all_keys_file|
	file = File.read(all_keys_file).split("\n")
	@doc = {}
	trd = Thread.new{
    		file.each_with_index do |line,index|      
      		  data = line.split(" ")
		      @doc[data[0]] = data[1]
    		end	
	}
	read_threads << trd
	documents << @doc
    end
    read_threads.map{|t| t.join}
    @documents = [@doc1,@doc2,@doc3,@doc4,@doc5,@doc6]    
    #cosine Similarity
    @similarities = []
    @times = []
    arr = []    
    (0..(documents.length-1)).each do |ind|
     data_array = []      
      time_array = []		
          (0..ind).each do |indj|         
			arr[ind] = Thread.new{		  
				somefile.puts Thread.current.to_s + "First Document "+ind.to_s + "- Second Document " + indj.to_s				 
				time1 = Time.now
                num = 0
                denom1  = 0
                denom2 = 0
    	        documents[ind].each do |k,v|
                  if (!documents[indj][k].nil?) && (documents[indj][k].to_i > 0) && (documents[ind][k].to_i > 0)
                        num += documents[ind][k].to_i*documents[indj][k].to_i
                        denom1 += documents[ind][k].to_i*documents[ind][k].to_i
                        denom2 += documents[indj][k].to_i*documents[indj][k].to_i
                  end  
                end
                sq_rt_denom1 = Math.sqrt(denom1)
                sq_rt_denom2 = Math.sqrt(denom2)
                @similarity = (num.to_f)/(sq_rt_denom1.to_f * sq_rt_denom2.to_f) #/
                data_array << @similarity
                time2 = Time.now
                time_array << time2-time1             
				}
		  end
      @times << time_array
      @similarities << data_array
    end
	arr.map{|t| t.join}
    puts @similarities.inspect
	somefile.close
    puts Time.now - @time1
end


############################################################
######## Cosine Algorithm  Inverted Index Parallel Programming ############
############################################################
def cosine_inverted_index
	@documents = ["d1a7.allKeys","d1au.allKeys","d1dl.allKeys","d1h8.allKeys","d1lt.allKeys","d1q3.allKeys"]
    @time1 = Time.now
    documents = []
    read_threads = []
    @keys_terms = {}
    #file1
    thread1 = Thread.new{
        file1 = File.read('./d1a7.allKeys').split("\n")
        @doc1 = {}
        file1.each_with_index do |line,index|      
          data = line.split(" ")
          if (@keys_terms[data[0]] == nil)
			@keys_terms[data[0]]=[[0,data[1].to_i]]
		  else
			@keys_terms[data[0]] << [0,data[1].to_i]
		  end
        end
    }
    #file2    
        file2 = File.read('./d1au.allKeys').split("\n")
        @doc2 = {}
        file2.each_with_index do |line,index|      
          data = line.split(" ")
          if (@keys_terms[data[0]] == nil)
			@keys_terms[data[0]]=[[1,data[1].to_i]]
		  else
			@keys_terms[data[0]] << [1,data[1].to_i]
		  end
        end
      
    #file3
    
    file3 = File.read('./d1dl.allKeys').split("\n")
    @doc3 = {}
    file3.each_with_index do |line,index|      
      data = line.split(" ")
      if (@keys_terms[data[0]] == nil)
		@keys_terms[data[0]]=[[2,data[1].to_i]]
	  else
		@keys_terms[data[0]] << [2,data[1].to_i]
	  end
      #@doc3[data[0]] = data[1]
    end
    
    #file4
  
    file4 = File.read('./d1h8.allKeys').split("\n")
    @doc4 = {}
    file4.each_with_index do |line,index|      
      data = line.split(" ")
      if (@keys_terms[data[0]] == nil)
		@keys_terms[data[0]]=[[3,data[1].to_i]]
	  else
		@keys_terms[data[0]] << [3,data[1].to_i]
	  end
      #@doc4[data[0]] = data[1]
    end
  
    #file5
  
    file5 = File.read('./d1lt.allKeys').split("\n")
    @doc5 = {}
    file5.each_with_index do |line,index|      
      data = line.split(" ")
      if (@keys_terms[data[0]] == nil)
		@keys_terms[data[0]]=[[4,data[1].to_i]]
	  else
		@keys_terms[data[0]] << [4,data[1].to_i]
	  end
    end
  
    #file6
  
    file6 = File.read('./d1q3.allKeys').split("\n")
    @doc6 = {}
    file6.each_with_index do |line,index|      
      data = line.split(" ")
      if (@keys_terms[data[0]] == nil)
		@keys_terms[data[0]]=[[5,data[1].to_i]]
	  else
		@keys_terms[data[0]] << [5,data[1].to_i]
	  end
    end    
  
    @similarities = []
    @numerators = []
    @denom1 = []
    @denom2 = []
    (0..5).each do |i|
      @numerators[i] = []
      @denom1[i] = []
      @denom2[i] = []
      @similarities[i] = []
      (0..5).each do |j|
        @numerators[i][j] = 0.0
        @denom1[i][j] = 0.0
        @denom2[i][j] = 0.0
      end  
    end

	@keys = @keys_terms.keys
	parts = @keys.each_slice(10000)
	trds = []
	parts.each do |part|
		trds << Thread.new{
			part.each do |key|
			   inv_indx = @keys_terms[key]
			  len = inv_indx.length - 1
			  len.step(0,-1) do |i|
				(0..i).each do |j|
					if(inv_indx[i][0] < inv_indx[j][0])
					  k = j
					  l = i
					else
					  k = i
					  l = j
					end
					@numerators[inv_indx[k][0]][inv_indx[l][0]] += inv_indx[k][1] * inv_indx[l][1]
					@denom1[inv_indx[k][0]][inv_indx[l][0]] += inv_indx[k][1] * inv_indx[k][1]
					@denom2[inv_indx[k][0]][inv_indx[l][0]] += inv_indx[l][1] * inv_indx[l][1]
				end
			  end
			end
	  }
	end
    trds.each{|t| t.join }
    (0..5).each do |i|
      (0..i).each do |j|
        sq_rt_denom1 = Math.sqrt(@denom1[i][j])
        sq_rt_denom2 = Math.sqrt(@denom2[i][j])
        @similarities[i][j] = (@numerators[i][j].to_f)/(sq_rt_denom1.to_f * sq_rt_denom2.to_f) #/
      end  
    end
    puts Time.now - @time1
  end



  

#cosine()
cosine_parallel()
#profile_printer = JRuby::Profiler::GraphProfilePrinter.new(profile_data)
#profile_printer.printProfile(STDOUT)
#cosine_parallel_keys()
#cosine_inverted_index()
