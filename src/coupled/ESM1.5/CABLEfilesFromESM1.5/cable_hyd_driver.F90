!==============================================================================
! This source code is part of the 
! Australian Community Atmosphere Biosphere Land Exchange (CABLE) model.
! This work is licensed under the CABLE Academic User Licence Agreement 
! (the "Licence").
! You may not use this file except in compliance with the Licence.
! A copy of the Licence and registration form can be obtained from 
! http://www.cawcr.gov.au/projects/access/cable
! You need to register and read the Licence agreement before use.
! Please contact cable_help@nf.nci.org.au for any questions on 
! registration and the Licence.
!
! Unless required by applicable law or agreed to in writing, 
! software distributed under the Licence is distributed on an "AS IS" BASIS,
! WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
! See the Licence for the specific language governing permissions and 
! limitations under the Licence.
! ==============================================================================
!
! Purpose: Converts selected CABLE hydrology variables to UM variables for 
!          UM hydrology code
!
! Called from: UM code hydrol
!
! Contact: Jhan.Srbinovsky@csiro.au
!
! History: Written for CABLE v1.8. No change for CABLE v2.0
!          In future could be combined with standard unpacking of cable 
!          variables at end of implicit call
!
!
! ==============================================================================

SUBROUTINE cable_hyd_driver( SNOW_TILE, LYING_SNOW, SURF_ROFF, SUB_SURF_ROFF,  &
                             TOT_TFALL, WB_LAKE )

   USE cable_common_module!, only : cable_runtime, cable_user
   USE cable_um_tech_mod, only : um1, ssnow, canopy, veg
   IMPLICIT NONE

   REAL, INTENT(OUT), DIMENSION(um1%LAND_PTS,um1%NTILES) ::                    &
      SNOW_TILE   ! IN Lying snow on tiles (kg/m2)        

   REAL, INTENT(OUT), DIMENSION(um1%LAND_PTS) ::                               &
      LYING_SNOW,    & ! OUT Gridbox snowmass (kg/m2)        
      SUB_SURF_ROFF, & !
      SURF_ROFF,     & !
      TOT_TFALL        !

   REAL, DIMENSION(um1%LAND_PTS,um1%NTILES) ::                                 &
      SURF_CAB_ROFF,    &
      TOT_TFALL_TILE                

   ! Lestevens 25sep13 - water balance fix for lakes
   REAL, DIMENSION(um1%land_pts,um1%ntiles) ::                                 &
      WB_LAKE         ! unpack CABLE wb_lake

   REAL :: miss =0. 
   
      SNOW_TILE= UNPACK(ssnow%snowd, um1%L_TILE_PTS, miss) 
      LYING_SNOW = SUM(um1%TILE_FRAC * SNOW_TILE,2) !gridbox snow mass

      SURF_CAB_ROFF  = UNPACK(ssnow%rnof1, um1%L_TILE_PTS, miss)
      SURF_ROFF      = SUM(um1%TILE_FRAC * SURF_CAB_ROFF,2)
      
      SURF_CAB_ROFF  = UNPACK(ssnow%rnof2, um1%L_TILE_PTS, miss)
      SUB_SURF_ROFF  = SUM(um1%TILE_FRAC * SURF_CAB_ROFF,2)

      TOT_TFALL_TILE = UNPACK(canopy%through, um1%L_TILE_PTS, miss)
      TOT_TFALL      = SUM(um1%TILE_FRAC * TOT_TFALL_TILE,2)

      ! Lest 25sep13 - wb_lake fix
      WB_LAKE        = UNPACK(ssnow%wb_lake, um1%L_TILE_PTS, miss)
      
END SUBROUTINE cable_hyd_driver
      




