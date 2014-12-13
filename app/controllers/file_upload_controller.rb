class FileUploadController < ApplicationController
  skip_before_filter :verify_authenticity_token
  def cosine_file_upload
    #file1
    file1 = params[:file1].read.split("\n")
    @doc1 = {}
    file1.each_with_index do |line,index|
      data = line.split(" ")
      @doc1[data[0]] = data[1]
    end
    #file2
    file2 = params[:file2].read.split("\n")
    @doc2 = {}
    file2.each_with_index do |line,index|
      data = line.split(" ")
      @doc2[data[0]] = data[1]
    end
    @time1 = Time.now
    ##Cosine Algorithm
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
     @similarity = (num.to_f)/(sq_rt_denom1.to_f * sq_rt_denom2.to_f)
     @distance = 1.0 - @similarity
     @time2 = Time.now - @time1
  end

  def jaccard_file_upload
    #file1
    file1 = params[:file1].read.split("\n")
    @doc1 = {}
    file1.each_with_index do |line,index|
      data = line.split(" ")
      @doc1[data[0]] = data[1] if data[1].to_i >0
    end
    #file2
    file2 = params[:file2].read.split("\n")
    @doc2 = {}
    file2.each_with_index do |line,index|
      data = line.split(" ")
      @doc2[data[0]] = data[1] if data[1].to_i >0
    end
    @time1 = Time.now
    ##Jaccard Algorithm
     common  = 0
     denom2 = 0
     @doc1.each do |k,v|
       if (@doc2[k].to_i > 0) && (v.to_i >0)
                  common += 1
       end
     end
     @similarity = (common.to_f)/(@doc1.length.to_f + @doc2.length.to_f - common.to_f)
     @distance = 1.0 - @similarity
     @time2 = Time.now - @time1
  end
end
