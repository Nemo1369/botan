/*
* File Tree Walking EntropySource
* (C) 1999-2008 Jack Lloyd
*
* Botan is released under the Simplified BSD License (see license.txt)
*/

#ifndef BOTAN_ENTROPY_SRC_PROC_WALK_H__
#define BOTAN_ENTROPY_SRC_PROC_WALK_H__

#include <botan/entropy_src.h>
#include <mutex>

namespace Botan {

class File_Descriptor_Source
   {
   public:
      virtual int next_fd() = 0;
      virtual ~File_Descriptor_Source() {}
   };

/**
* File Tree Walking Entropy Source
*/
class ProcWalking_EntropySource final : public Entropy_Source
   {
   public:
      std::string name() const override { return "proc_walk"; }

      void poll(Entropy_Accumulator& accum) override;

      ProcWalking_EntropySource(const std::string& root_dir) :
         m_path(root_dir), m_dir(nullptr) {}

   private:
      const std::string m_path;
      std::mutex m_mutex;
      std::unique_ptr<File_Descriptor_Source> m_dir;
      secure_vector<byte> m_buf;
   };

}

#endif
