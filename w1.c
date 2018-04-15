	/*
#include "types.h"
#include "stat.h"
#include "fcntl.h"
#include "defs.h"
#include "fs.h"
#include "buf.h"
#include "spinlock.h"
#include "sleeplock.h"
#include "proc.h"
#include "param.h"
#include "mmu.h"
#include "file.h"
struct superblock sb;
*/

int main(int argc, char **argv) {
	/*
	int inum;
	struct buf *bp;
	struct dinode *dip;
	struct superblock sb;
	readsb(1,&sb);
	for(inum = 1; inum < sb.ninodes; inum++){
		bp = bread(1, IBLOCK(inum, sb));
		dip = (struct dinode*)bp->data + inum%IPB;
		if(dip->type == 0){  // a free inode
			cprintf("Skipping inode #: %d",inum);
		}
		else{
			// Found allocated inode
			cprintf("inode #: %d, has type: %d",inum,dip->type);
		}
		brelse(bp);
	}

	exit();
	*/
	return 0;
}

