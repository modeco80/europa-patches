# HostFS patch

Does basically what it says on the tin.

# Current status

This patch currently functions as a proof of concept. 

This proof of concept thunks CPS2CDStore methods to the CPS2DiskStore, which *can* use the host filesystem (without altering the path yet). This has been demonstrated to at least boot and get in game, which implies that it should be usable as the basis of a fully working HostFS patch.

However, there are still some unaddressed big problems (ordered in relative severity):
- LECAL on the EE currently sends OPEN_DIRECT_FAST calls to the IOP, with sector information, to open audio streams.
    - *However*, this could be fixed. There is leftover LECAL EE code to open via a
       filename, and the LECAL IOP module has not had support for this stripped out (in fact, it's extremely chatty with debug information if you give it the chance to be.). In this mode, it will also use FIO calls, which means this mode should work
       with HostFS; it's just a matter of seeing what's available
- PSS video playback use sceCdSt*() functions, which can't be made HostFS.
    - I'm unsure of how to deal with this, because the only way I can think of is
        to just hook the code and have a C++ blob completely reimplement it in a 
        way where HostFS can be used, or somehow shim the cd stream code. 
        Neither of the options seem particularly fun or trivial.

