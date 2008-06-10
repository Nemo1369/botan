/*************************************************
* RandomNumberGenerator Header File              *
* (C) 1999-2008 Jack Lloyd                       *
*************************************************/

#ifndef BOTAN_RANDOM_NUMBER_GENERATOR__
#define BOTAN_RANDOM_NUMBER_GENERATOR__

#include <botan/exceptn.h>

namespace Botan {

/*************************************************
* Entropy Source                                 *
*************************************************/
class BOTAN_DLL EntropySource
   {
   public:
      virtual u32bit slow_poll(byte[], u32bit) = 0;
      virtual u32bit fast_poll(byte[], u32bit);
      virtual ~EntropySource() {}
   };

/*************************************************
* Random Number Generator                        *
*************************************************/
class BOTAN_DLL RandomNumberGenerator
   {
   public:
      virtual void randomize(byte[], u32bit) throw(PRNG_Unseeded) = 0;
      virtual bool is_seeded() const = 0;
      virtual void clear() throw() {};

      byte next_byte();

      void add_entropy(const byte[], u32bit);
      u32bit add_entropy(EntropySource&, bool = true);

      virtual ~RandomNumberGenerator() {}
   private:
      virtual void add_randomness(const byte[], u32bit) = 0;
   };

}

#endif
