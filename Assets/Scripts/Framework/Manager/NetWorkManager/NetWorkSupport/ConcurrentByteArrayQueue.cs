using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;


public class ConcurrentByteArrayQueue
{
    Queue<Byte[]> queue = new Queue<byte[]>();
    int count = 0;
    public int Count {
        get {
            return count;
        }
    }



    public void Enqueue(byte[] item)
    {
        lock (this)
        {
            queue.Enqueue(item);
            count = queue.Count;
        }

        
    }

    public byte[] Dequeue()
    {
        byte[] item = null;
        lock (this)
        {
            if (queue.Count == 0)
            {
                return null;
            }
            item = queue.Dequeue();
            count = queue.Count;
        }
        return item;
    }

    public void Clear()
    {
        lock (this)
        {
            queue.Clear();
            count = queue.Count;
        }
    }
}

