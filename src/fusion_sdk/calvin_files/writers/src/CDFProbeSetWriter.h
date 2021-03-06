////////////////////////////////////////////////////////////////
//
// Copyright (C) 2005 Affymetrix, Inc.
//
// This library is free software; you can redistribute it and/or modify
// it under the terms of the GNU Lesser General Public License 
// (version 2.1) as published by the Free Software Foundation.
// 
// This library is distributed in the hope that it will be useful, but
// WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
// or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License
// for more details.
// 
// You should have received a copy of the GNU Lesser General Public License
// along with this library; if not, write to the Free Software Foundation, Inc.,
// 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA 
//
////////////////////////////////////////////////////////////////
#ifndef _CDFProbeSetWriter_HEADER_
#define _CDFProbeSetWriter_HEADER_

#include "calvin_files/writers/src/DataSetWriter.h"
//
#include <fstream>
//

#ifdef _MSC_VER
#pragma warning(disable: 4290) // don't show warnings about throw keyword on function declarations.
#endif

namespace affymetrix_calvin_io
{

class CDFProbeSetWriter
{

public:

	CDFProbeSetWriter(DataSetWriter* dpw) { writer = dpw; };
	~CDFProbeSetWriter() { delete writer; };

private:

	DataSetWriter* writer;

public:

	void WriteHeader();

	void Close();

	void Write(u_int16_t xCoord,
						 u_int16_t yCoord,
						 u_int32_t atom,
						 u_int32_t indexPos,
						 int8_t baseProbe,
						 int8_t baseTarget);

};

}

#endif // _CDFProbeSetWriter_HEADER_
