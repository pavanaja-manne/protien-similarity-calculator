require 'ruby-prof'
require 'benchmark'
class CalculatorController < ApplicationController
  skip_before_filter :verify_authenticity_token
  
  ############################################################
  ######## Cosine Algorithm ################################
  ############################################################
  def cosine    
    @time1 = Time.now
    documents = []
    @document_names = ["d1a7.allKeys","d1au.allKeys","d1dl.allKeys","d1h8.allKeys","d1lt.allKeys","d1q3.allKeys"]
    #file1    
    file1 = File.read(Rails.root.join('public/files/d1a7.allKeys')).split("\n")
    @doc1 = {}
    file1.each_with_index do |line,index|      
      data = line.split(" ")
      @doc1[data[0]] = data[1]
    end
    #file2
    file2 = File.read(Rails.root.join('public/files/d1au.allKeys')).split("\n")
    @doc2 = {}
    file2.each_with_index do |line,index|      
      data = line.split(" ")
      @doc2[data[0]] = data[1]      
    end
    #file3
    file3 = File.read(Rails.root.join('public/files/d1dl.allKeys')).split("\n")
    @doc3 = {}
    file3.each_with_index do |line,index|      
      data = line.split(" ")
      @doc3[data[0]] = data[1]
    end
    #file4
    file4 = File.read(Rails.root.join('public/files/d1h8.allKeys')).split("\n")
    @doc4 = {}
    file4.each_with_index do |line,index|      
      data = line.split(" ")
      @doc4[data[0]] = data[1]
    end
    #file5
    file5 = File.read(Rails.root.join('public/files/d1lt.allKeys')).split("\n")
    @doc5 = {}
    file5.each_with_index do |line,index|      
      data = line.split(" ")
      @doc5[data[0]] = data[1]
    end
    #file6
    file6 = File.read(Rails.root.join('public/files/d1q3.allKeys')).split("\n")
    @doc6 = {}
    file6.each_with_index do |line,index|      
      data = line.split(" ")
      @doc6[data[0]] = data[1]
    end    
    @documents = [@doc1,@doc2,@doc3,@doc4,@doc5,@doc6]  
    #cosine Similarity
    @times = []
    @similarities = []
    (0..5).each do |ind|
      data_array = []
      time_array = []
      (0..ind).each do |indj|
        time1 = Time.now
        num = 0
        denom1  = 0
        denom2 = 0
        @documents[ind].each do |k,v|
          if (!@documents[indj][k].nil?) && (@documents[indj][k].to_i > 0) && (@documents[ind][k].to_i > 0)
                num += @documents[ind][k].to_i*@documents[indj][k].to_i
                denom1 += @documents[ind][k].to_i*@documents[ind][k].to_i
                denom2 += @documents[indj][k].to_i*@documents[indj][k].to_i
          end  
        end
        sq_rt_denom1 = Math.sqrt(denom1)
        sq_rt_denom2 = Math.sqrt(denom2)
        @similarity = (num.to_f)/(sq_rt_denom1.to_f * sq_rt_denom2.to_f) #/
        time2 = Time.now
        time_array << time2 - time1
        data_array << @similarity
        @time_taken = TimeTaken.where(:file1 => @document_names[ind], :file2 => @document_names[indj], :method => "cosine").first
        if @time_taken.nil?
          @time_taken = TimeTaken.new
        end
        @time_taken.file1 = @document_names[ind]
        @time_taken.file2 = @document_names[indj]
        @time_taken.time = (time2 - time1).to_s
        @time_taken.similarity = @similarity
        @time_taken.method = "cosine"
        @time_taken.save

        #@distance = 1.0 - @similarity 
      end
      @times << time_array
      @similarities << data_array
    end  
     @time2 = Time.now
  end
  
  
  
  ############################################################
  ######## Cosine Algorithm  Parallel Programming ############
  ############################################################
  def cosine_parallel    
    @time1 = Time.now
    documents = []
    read_threads = []
    #file1
    thread1 = Thread.new{
        file1 = File.read(Rails.root.join('public/files/d1a7.allKeys')).split("\n")
        @doc1 = {}
        file1.each_with_index do |line,index|      
          data = line.split(" ")
          @doc1[data[0]] = data[1]
        end
    }
    #file2
    thread2 = Thread.new{
        file2 = File.read(Rails.root.join('public/files/d1au.allKeys')).split("\n")
        @doc2 = {}
        file2.each_with_index do |line,index|      
          data = line.split(" ")
          @doc2[data[0]] = data[1]      
        end
      }
    #file3
    thread3 = Thread.new{
    file3 = File.read(Rails.root.join('public/files/d1dl.allKeys')).split("\n")
    @doc3 = {}
    file3.each_with_index do |line,index|      
      data = line.split(" ")
      @doc3[data[0]] = data[1]
    end
    }
    #file4
    thread4 = Thread.new{
      file4 = File.read(Rails.root.join('public/files/d1h8.allKeys')).split("\n")
      @doc4 = {}
      file4.each_with_index do |line,index|      
        data = line.split(" ")
        @doc4[data[0]] = data[1]
      end
    }
    #file5
    thread5 = Thread.new{
        file5 = File.read(Rails.root.join('public/files/d1lt.allKeys')).split("\n")
        @doc5 = {}
        file5.each_with_index do |line,index|      
          data = line.split(" ")
          @doc5[data[0]] = data[1]
        end
    }
    #file6
  thread6 = Thread.new{
    file6 = File.read(Rails.root.join('public/files/d1q3.allKeys')).split("\n")
    @doc6 = {}
    file6.each_with_index do |line,index|      
      data = line.split(" ")
      @doc6[data[0]] = data[1]
    end    
    }
    thread1.join
    thread2.join
    thread3.join
    thread4.join
    thread5.join
    thread6.join
    @documents = [@doc1,@doc2,@doc3,@doc4,@doc5,@doc6]    
    #cosine Similarity
    @similarities = []
    @times = []
    arr = []    
    (0..5).each do |ind|
     data_array = []      
      time_array = []
          (0..ind).each do |indj|            
            arr[ind] = Thread.new{
              time1 = Time.now
                num = 0
                denom1  = 0
                denom2 = 0
                @documents[ind].each do |k,v|
                  if (!@documents[indj][k].nil?) && (@documents[indj][k].to_i > 0) && (@documents[ind][k].to_i > 0)
                        num += @documents[ind][k].to_i*@documents[indj][k].to_i
                        denom1 += @documents[ind][k].to_i*@documents[ind][k].to_i
                        denom2 += @documents[indj][k].to_i*@documents[indj][k].to_i
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
    
    RubyProf.start
       arr.each {|t|
         t.join;
      }

    @result = RubyProf.stop
    @time2 = Time.now
    
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
        file1 = File.read(Rails.root.join('public/files/d1a7.allKeys')).split("\n")
        @doc1 = {}
        file1.each_with_index do |line,index|      
          data = line.split(" ")
          (@keys_terms[data[0]].nil?)?(@keys_terms[data[0]]=[[0,data[1].to_i]]):(@keys_terms[data[0]] << [0,data[1].to_i])  
        end
    }
    #file2
    thread2 = Thread.new{
        file2 = File.read(Rails.root.join('public/files/d1au.allKeys')).split("\n")
        @doc2 = {}
        file2.each_with_index do |line,index|      
          data = line.split(" ")
          (@keys_terms[data[0]].nil?)?(@keys_terms[data[0]]=[[1,data[1].to_i]]):(@keys_terms[data[0]] << [1,data[1].to_i])  
        end
      }
    #file3
    thread3 = Thread.new{
    file3 = File.read(Rails.root.join('public/files/d1dl.allKeys')).split("\n")
    @doc3 = {}
    file3.each_with_index do |line,index|      
      data = line.split(" ")
      (@keys_terms[data[0]].nil?)?(@keys_terms[data[0]]=[[2,data[1].to_i]]):(@keys_terms[data[0]] << [2,data[1].to_i])  
      #@doc3[data[0]] = data[1]
    end
    }
    #file4
  thread4 = Thread.new{
    file4 = File.read(Rails.root.join('public/files/d1h8.allKeys')).split("\n")
    @doc4 = {}
    file4.each_with_index do |line,index|      
      data = line.split(" ")
      (@keys_terms[data[0]].nil?)?(@keys_terms[data[0]]=[[3,data[1].to_i]]):(@keys_terms[data[0]] << [3,data[1].to_i])  
      #@doc4[data[0]] = data[1]
    end
    }
    #file5
  thread5 = Thread.new{
    file5 = File.read(Rails.root.join('public/files/d1lt.allKeys')).split("\n")
    @doc5 = {}
    file5.each_with_index do |line,index|      
      data = line.split(" ")
      (@keys_terms[data[0]].nil?)?(@keys_terms[data[0]]=[[4,data[1].to_i]]):(@keys_terms[data[0]] << [4,data[1].to_i])  
    end
    }
    #file6
  thread6 = Thread.new{
    file6 = File.read(Rails.root.join('public/files/d1q3.allKeys')).split("\n")
    @doc6 = {}
    file6.each_with_index do |line,index|      
      data = line.split(" ")
      (@keys_terms[data[0]].nil?)?(@keys_terms[data[0]]=[[5,data[1].to_i]]):(@keys_terms[data[0]] << [5,data[1].to_i])  
    end    
    }
    thread1.join
    thread2.join
    thread3.join
    thread4.join
    thread5.join
    thread6.join
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
	parts = @keys.each_slice(20000)
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
      (0..5).each do |j|
        sq_rt_denom1 = Math.sqrt(@denom1[i][j])
        sq_rt_denom2 = Math.sqrt(@denom2[i][j])
        @similarities[i][j] = (@numerators[i][j].to_f)/(sq_rt_denom1.to_f * sq_rt_denom2.to_f) #/
      end  
    end
    @time2 = Time.now
  end





  ############################################################
  ######## Tanimoto Algorithm ################################
  ############################################################
  def tanimoto    
    documents = []
    #file1    
    file1 = File.read(Rails.root.join('public/files/d1a7.allKeys')).split("\n")
    @doc1 = {}
    file1.each_with_index do |line,index|      
      data = line.split(" ")
      @doc1[data[0]] = data[1]
    end
    #file2
    file2 = File.read(Rails.root.join('public/files/d1au.allKeys')).split("\n")
    @doc2 = {}
    file2.each_with_index do |line,index|      
      data = line.split(" ")
      @doc2[data[0]] = data[1]      
    end
    #file3
    file3 = File.read(Rails.root.join('public/files/d1dl.allKeys')).split("\n")
    @doc3 = {}
    file3.each_with_index do |line,index|      
      data = line.split(" ")
      @doc3[data[0]] = data[1]
    end
    #file4
    file4 = File.read(Rails.root.join('public/files/d1h8.allKeys')).split("\n")
    @doc4 = {}
    file4.each_with_index do |line,index|      
      data = line.split(" ")
      @doc4[data[0]] = data[1]
    end
    #file5
    file5 = File.read(Rails.root.join('public/files/d1lt.allKeys')).split("\n")
    @doc5 = {}
    file5.each_with_index do |line,index|      
      data = line.split(" ")
      @doc5[data[0]] = data[1]
    end
    #file6
    file6 = File.read(Rails.root.join('public/files/d1q3.allKeys')).split("\n")
    @doc6 = {}
    file6.each_with_index do |line,index|      
      data = line.split(" ")
      @doc6[data[0]] = data[1]
    end    
    @documents = [@doc1,@doc2,@doc3,@doc4,@doc5,@doc6]
    
   #Tanimoto Algorithm
     num = 0
     denom1  = 0
     denom2 = 0
     @doc1.each do |k,v|
       if !@doc2[k].nil?
             num += @doc1[k].to_i*@doc2[k].to_i
             denom1 += @doc1[k].to_i*@doc1[k].to_i
             denom2 += @doc2[k].to_i*@doc2[k].to_i
       end  
     end
     sq_rt_denom1 = Math.sqrt(denom1)
     sq_rt_denom2 = Math.sqrt(denom2)
     @similarity = (num.to_f)/(sq_rt_denom1.to_f * sq_rt_denom2.to_f) #/
     @distance = 1.0 - @similarity 

    
    #cosine Similarity
    @similarities = []
    (0..5).each do |ind|
      data_array = []
      (0..ind).each do |indj|
        num = 0
        denom1  = 0
        denom2 = 0
        @documents[ind].each do |k,v|
          if (!@documents[indj][k].nil?) && (@documents[indj][k].to_i > 0) && (@documents[ind][k].to_i > 0)
                num += @documents[ind][k].to_i*@documents[indj][k].to_i
                denom1 += @documents[ind][k].to_i*@documents[ind][k].to_i
                denom2 += @documents[indj][k].to_i*@documents[indj][k].to_i
          end  
        end
        sq_rt_denom1 = Math.sqrt(denom1)
        sq_rt_denom2 = Math.sqrt(denom2)
        @similarity = (num.to_f)/(sq_rt_denom1.to_f + sq_rt_denom2.to_f - num.to_f) #/
        data_array << @similarity
        #@distance = 1.0 - @similarity 
      end
      @similarities << data_array
    end    
  end




  ############################################################
  ######## Jaccard Algorithm #################################
  ############################################################
  def jaccard    
    @document_names = ["d1a7.allKeys","d1au.allKeys","d1dl.allKeys","d1h8.allKeys","d1lt.allKeys","d1q3.allKeys"]
    #file1    
    file1 = File.read(Rails.root.join('public/files/d1a7.allKeys')).split("\n")
    @doc1 = {}
    file1.each_with_index do |line,index|      
      data = line.split(" ")
      @doc1[data[0]] = data[1]
    end
    #file2
    file2 = File.read(Rails.root.join('public/files/d1au.allKeys')).split("\n")
    @doc2 = {}
    file2.each_with_index do |line,index|      
      data = line.split(" ")
      @doc2[data[0]] = data[1]      
    end
    #file3
    file3 = File.read(Rails.root.join('public/files/d1dl.allKeys')).split("\n")
    @doc3 = {}
    file3.each_with_index do |line,index|      
      data = line.split(" ")
      @doc3[data[0]] = data[1]
    end
    #file4
    file4 = File.read(Rails.root.join('public/files/d1h8.allKeys')).split("\n")
    @doc4 = {}
    file4.each_with_index do |line,index|      
      data = line.split(" ")
      @doc4[data[0]] = data[1]
    end
    #file5
    file5 = File.read(Rails.root.join('public/files/d1lt.allKeys')).split("\n")
    @doc5 = {}
    file5.each_with_index do |line,index|      
      data = line.split(" ")
      @doc5[data[0]] = data[1]
    end
    #file6
    file6 = File.read(Rails.root.join('public/files/d1q3.allKeys')).split("\n")
    @doc6 = {}
    file6.each_with_index do |line,index|      
      data = line.split(" ")
      @doc6[data[0]] = data[1]
    end    
    @document = [@doc1,@doc2,@doc3,@doc4,@doc5,@doc6]
    
    #Jaccard Algorithm
    @times = []
    @similarities = []
    (0..5).each do |ind|
      data_array = []
      time_array = []
      (0..ind).each do |indj|
            time1 = Time.now
            common = 0
            @document[ind].each do |k,v|                
                if (@document[ind][k].to_i > 0) && (@document[indj][k].to_i >0)
                  common += 1
                end                            
            end
        @jaccard_similarity = common.to_f/(@document[ind].length.to_f + @document[indj].length.to_f - common.to_f)        
        data_array << @jaccard_similarity
        time2 = Time.now
        time_array << time2 - time1
        @time_taken = TimeTaken.where(:file1 => @document_names[ind], :file2 => @document_names[indj], :method => "jaccard").first
        if @time_taken.nil?
          @time_taken = TimeTaken.new
        end
        @time_taken.file1 = @document_names[ind]
        @time_taken.file2 = @document_names[indj]
        @time_taken.time = (time2 - time1).to_s
        @time_taken.method = "jaccard"
        @time_taken.similarity = @jaccard_similarity
        @time_taken.save
      end
      @times << time_array
      @similarities << data_array
    end    
  end
  
  ############################################################
  ######## Jaccard Algorithm Different Style Based Weights ###
  ############################################################
  def jaccard_weights    
    documents = []
    #file1    
    file1 = File.read(Rails.root.join('public/files/d1a7.allKeys')).split("\n")
    @doc1 = {}
    file1.each_with_index do |line,index|      
      data = line.split(" ")
      @doc1[data[0]] = data[1]
    end
    #file2
    file2 = File.read(Rails.root.join('public/files/d1au.allKeys')).split("\n")
    @doc2 = {}
    file2.each_with_index do |line,index|      
      data = line.split(" ")
      @doc2[data[0]] = data[1]      
    end
    #file3
    file3 = File.read(Rails.root.join('public/files/d1dl.allKeys')).split("\n")
    @doc3 = {}
    file3.each_with_index do |line,index|      
      data = line.split(" ")
      @doc3[data[0]] = data[1]
    end
    #file4
    file4 = File.read(Rails.root.join('public/files/d1h8.allKeys')).split("\n")
    @doc4 = {}
    file4.each_with_index do |line,index|      
      data = line.split(" ")
      @doc4[data[0]] = data[1]
    end
    #file5
    file5 = File.read(Rails.root.join('public/files/d1lt.allKeys')).split("\n")
    @doc5 = {}
    file5.each_with_index do |line,index|      
      data = line.split(" ")
      @doc5[data[0]] = data[1]
    end
    #file6
    file6 = File.read(Rails.root.join('public/files/d1q3.allKeys')).split("\n")
    @doc6 = {}
    file6.each_with_index do |line,index|      
      data = line.split(" ")
      @doc6[data[0]] = data[1]
    end    
    @document = [@doc1,@doc2,@doc3,@doc4,@doc5,@doc6]
    
    #Jaccard Algorithm
    @similarities = []
    (0..5).each do |ind|
      data_array = []
      (0..ind).each do |indj|        
            numerator = 0
            denominator = 0
        @document[ind].each do |k,v|
              if !@document[indj][k].nil?
                    if @document[ind][k].to_i > @document[indj][k].to_i
                        numerator += @document[indj][k].to_i
                        denominator += @document[ind][k].to_i
                    else
                        numerator += @document[ind][k].to_i
                        denominator += @document[indj][k].to_i
                    end            
              end  
            end
            @jaccard_similarity = numerator.to_f/denominator.to_f        
        data_array << @jaccard_similarity        
      end
      @similarities << data_array
    end    
  end


  ##################################################
  ############ Time Storage Cosine Parallel #################
  ##################################################

  def cosine_storage_parallel
    @document_names = ["d1a7.allKeys","d1au.allKeys","d1dl.allKeys","d1h8.allKeys","d1lt.allKeys","d1q3.allKeys"]
    @keys_terms = {}        
        @similarity = 0.0
        @numerator = 0.0
        @denom1 = 0.0
        @denom2 = 0.0        
        file1 = File.read(Rails.root.join('public/files/'+@document_names[params[:file1].to_i])).split("\n")
        file1.each_with_index do |line,index|
          data = line.split(" ")
          (@keys_terms[data[0]].nil?)?(@keys_terms[data[0]]=[[0,data[1].to_i]]):(@keys_terms[data[0]] << [0,data[1].to_i])
        end
        file2 = File.read(Rails.root.join('public/files/'+@document_names[params[:file1].to_i])).split("\n")
        file2.each_with_index do |line,index|
          data = line.split(" ")
          (@keys_terms[data[0]].nil?)?(@keys_terms[data[0]]=[[0,data[1].to_i]]):(@keys_terms[data[0]] << [0,data[1].to_i])
        end        
        time1 = Time.now
        @keys = @keys_terms.keys
        parts = @keys.each_slice((@keys_terms.length/4).to_i)
        trds = []
        parts.each do |part|
          #trds << Thread.new{
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
                @numerator += inv_indx[k][1] * inv_indx[l][1]
                @denom1 += inv_indx[k][1] * inv_indx[k][1]
                @denom2 += inv_indx[l][1] * inv_indx[l][1]
              end
              end
            end
         # }
        end
       # trds.each{|t| t.join }
        sq_rt_denom1 = Math.sqrt(@denom1)
        sq_rt_denom2 = Math.sqrt(@denom2)
        @similarity = (@numerator.to_f)/(sq_rt_denom1.to_f * sq_rt_denom2.to_f) #/
        time2 = Time.now
        @time_taken = TimeTaken.where(:file1 => @document_names[params[:file1].to_i], :file2 => @document_names[params[:file2].to_i],:method => "cosine_inverted_index_parallel").first
        if @time_taken.nil?
          @time_taken = TimeTaken.new
        end
        @time_taken.file1 = @document_names[params[:file1].to_i]
        @time_taken.file2 = @document_names[params[:file2].to_i]
        @time_taken.time = (time2 - time1).to_s
        @time_taken.method = "cosine_inverted_index_parallel"
        @time_taken.similarity = @similarity
        @time_taken.save
       
  end

  def cosine_storage
      @documents = ["d1a7.allKeys","d1au.allKeys","d1dl.allKeys","d1h8.allKeys","d1lt.allKeys","d1q3.allKeys"]
      @time1 = Time.now
      @keys_terms = {}
      #file1
      file1 = File.read(Rails.root.join('public/files/d1a7.allKeys')).split("\n")
      @doc1 = {}
      file1.each_with_index do |line,index|
        data = line.split(" ")
        (@keys_terms[data[0]].nil?)?(@keys_terms[data[0]]=[[0,data[1].to_i]]):(@keys_terms[data[0]] << [0,data[1].to_i])
      end
      
      #file2      
      file2 = File.read(Rails.root.join('public/files/d1au.allKeys')).split("\n")
      @doc2 = {}
      file2.each_with_index do |line,index|
        data = line.split(" ")
        (@keys_terms[data[0]].nil?)?(@keys_terms[data[0]]=[[1,data[1].to_i]]):(@keys_terms[data[0]] << [1,data[1].to_i])
      end
        
      #file3      
      file3 = File.read(Rails.root.join('public/files/d1dl.allKeys')).split("\n")
      @doc3 = {}
      file3.each_with_index do |line,index|
        data = line.split(" ")
        (@keys_terms[data[0]].nil?)?(@keys_terms[data[0]]=[[2,data[1].to_i]]):(@keys_terms[data[0]] << [2,data[1].to_i])
        #@doc3[data[0]] = data[1]
      end
      
      #file4
      thread4 = Thread.new{
        file4 = File.read(Rails.root.join('public/files/d1h8.allKeys')).split("\n")
        @doc4 = {}
        file4.each_with_index do |line,index|
          data = line.split(" ")
          (@keys_terms[data[0]].nil?)?(@keys_terms[data[0]]=[[3,data[1].to_i]]):(@keys_terms[data[0]] << [3,data[1].to_i])
          #@doc4[data[0]] = data[1]
        end
        }
        #file5
      thread5 = Thread.new{
        file5 = File.read(Rails.root.join('public/files/d1lt.allKeys')).split("\n")
        @doc5 = {}
        file5.each_with_index do |line,index|
          data = line.split(" ")
          (@keys_terms[data[0]].nil?)?(@keys_terms[data[0]]=[[4,data[1].to_i]]):(@keys_terms[data[0]] << [4,data[1].to_i])
        end
        }
        #file6
      thread6 = Thread.new{
        file6 = File.read(Rails.root.join('public/files/d1q3.allKeys')).split("\n")
        @doc6 = {}
        file6.each_with_index do |line,index|
          data = line.split(" ")
          (@keys_terms[data[0]].nil?)?(@keys_terms[data[0]]=[[5,data[1].to_i]]):(@keys_terms[data[0]] << [5,data[1].to_i])
        end
        }
    
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
	parts = @keys.each_slice(20000)
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
      (0..5).each do |j|
        sq_rt_denom1 = Math.sqrt(@denom1[i][j])
        sq_rt_denom2 = Math.sqrt(@denom2[i][j])
        @similarities[i][j] = (@numerators[i][j].to_f)/(sq_rt_denom1.to_f * sq_rt_denom2.to_f) #/
      end
    end
    @time2 = Time.now
  end
end
