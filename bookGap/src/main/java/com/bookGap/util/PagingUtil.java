package com.bookGap.util;

public class PagingUtil {
	private int nowPage;  
	private int startPage;
	private int endPage;  
	private int total;	  
	private int perPage;  
	private int lastPage; 
	private int start;    
	private int end;      
	private int cntPage=5;
	
	public PagingUtil() {}
	public PagingUtil(int nowPage,int total, int perPage) {
		setNowPage(nowPage);
		setTotal(total);
		setPerPage(perPage);
		
		calcStartEnd(nowPage,perPage); 
		calcLastPage(total, perPage);
		calcStartEndPage(nowPage,cntPage);
	}
	
	public void calcStartEnd(int nowPage,int perPage) {
		int end = nowPage * perPage; 
		int start = end - perPage; 
		
		setEnd(end);
		setStart(start);
	}
	
	public void calcLastPage(int total, int perPage) {
		int lastPage = (int)Math.ceil((double)total/perPage);
		setLastPage(lastPage);
	}
	
	public void calcStartEndPage(int nowPage,int cntPage) {
		int endPage = (int)Math.ceil((double)nowPage / cntPage) * cntPage;
		
		int startPage = endPage - cntPage + 1;

		if(endPage > lastPage) {
			endPage = lastPage;
		}
		
		setEndPage(endPage);
		setStartPage(startPage);
	}
	
	public int getNowPage()   { return nowPage;   }
	public int getStartPage() { return startPage; }
	public int getEndPage()   { return endPage;   }
	public int getTotal()     { return total;     }
	public int getPerPage()   { return perPage;   }
	public int getLastPage()  { return lastPage;  }
	public int getStart()     { return start;     }
	public int getEnd()       { return end;       }
	public int getCntPage()   { return cntPage;   }
	
	public void setNowPage(int nowPage)     { this.nowPage = nowPage;	  }
	public void setStartPage(int startPage) { this.startPage = startPage; }
	public void setEndPage(int endPage)     { this.endPage = endPage;	  }
	public void setTotal(int total)         { this.total = total;	      }
	public void setPerPage(int perPage)     { this.perPage = perPage;	  }
	public void setLastPage(int lastPage)   { this.lastPage = lastPage;	  }
	public void setStart(int start)         { this.start = start;	      }
	public void setEnd(int end)             { this.end = end;	          }
	public void setCntPage(int cntPage)     { this.cntPage = cntPage;	  }

}
